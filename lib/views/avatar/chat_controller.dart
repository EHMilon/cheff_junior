import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/websocket_service.dart';
import '../../shared/utils/looger_utills.dart';

/// Chat Controller for managing chat screen lifecycle and state
/// Handles WebSocket connection lifecycle tied to screen visibility
class ChatController extends GetxController with WidgetsBindingObserver {
  // Services
  final WebSocketService _webSocketService = WebSocketService.instance;
  final AuthService _authService = Get.find<AuthService>();

  // Observable state
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Rx<WsConnectionState> connectionState = WsConnectionState.disconnected.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasMoreMessages = true.obs;

  // Message input
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Subscriptions
  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription<WsConnectionState>? _connectionStateSubscription;
  StreamSubscription<String>? _errorSubscription;

  // Screen visibility
  bool _isScreenVisible = false;
  bool get isScreenVisible => _isScreenVisible;

  String? get currentUserId => _authService.currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    // Register for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    _initializeWebSocket();
  }

  @override
  void onReady() {
    super.onReady();
    // Screen is now visible
    _isScreenVisible = true;
    _connectIfNeeded();
  }

  @override
  void onClose() {
    // Screen is being closed - disconnect WebSocket
    _isScreenVisible = false;
    _cleanup();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground
        if (_isScreenVisible) {
          Log.i('[ChatController] App resumed, connecting WebSocket');
          _connectIfNeeded();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        // App went to background - disconnect to save resources
        if (_isScreenVisible) {
          Log.i('[ChatController] App backgrounded, disconnecting WebSocket');
          _webSocketService.disconnect();
        }
        break;
      case AppLifecycleState.detached:
        // App is being destroyed
        _cleanup();
        break;
    }
  }

  /// Called when user navigates away from chat screen (but not closing)
  void onScreenHidden() {
    _isScreenVisible = false;
    Log.i('[ChatController] Screen hidden, disconnecting WebSocket');
    _webSocketService.disconnect();
  }

  /// Called when user returns to chat screen
  void onScreenVisible() {
    _isScreenVisible = true;
    Log.i('[ChatController] Screen visible, connecting WebSocket');
    _connectIfNeeded();
  }

  /// Initialize WebSocket service and setup listeners
  void _initializeWebSocket() {
    // Listen to incoming messages
    _messageSubscription = _webSocketService.messageStream.listen(
      _onMessageReceived,
      onError: (error) {
        Log.e('[ChatController] Message stream error: $error');
      },
    );

    // Listen to connection state changes
    _connectionStateSubscription = _webSocketService.connectionStateStream.listen(
      (state) {
        connectionState.value = state;
        Log.i('[ChatController] Connection state: $state');
      },
      onError: (error) {
        Log.e('[ChatController] Connection state stream error: $error');
      },
    );

    // Listen to errors
    _errorSubscription = _webSocketService.errorStream.listen(
      (error) {
        errorMessage.value = error;
        Log.e('[ChatController] WebSocket error: $error');
      },
      onError: (error) {
        Log.e('[ChatController] Error stream error: $error');
      },
    );
  }

  /// Connect WebSocket if user is authenticated
  Future<void> _connectIfNeeded() async {
    if (currentUserId == null) {
      Log.w('[ChatController] Cannot connect: no user ID');
      errorMessage.value = 'Please login to use chat';
      return;
    }

    if (_webSocketService.isConnected || _webSocketService.isConnecting) {
      Log.d('[ChatController] Already connected or connecting');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _webSocketService.connect(currentUserId!);
    } catch (e) {
      Log.e('[ChatController] Connection error: $e');
      errorMessage.value = 'Failed to connect: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle incoming message
  void _onMessageReceived(ChatMessage message) {
    messages.add(message);
    _scrollToBottom();
  }

  /// Send text message
  Future<void> sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    if (!_webSocketService.isConnected) {
      errorMessage.value = 'Not connected to chat server';
      return;
    }

    // Create optimistic message for UI
    final optimisticMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUserId ?? 'unknown',
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
      status: MessageStatus.sending,
    );

    // Add to UI immediately
    messages.add(optimisticMessage);
    messageController.clear();
    _scrollToBottom();

    // Send via WebSocket
    final success = await _webSocketService.sendMessage(content);

    if (success) {
      // Update status to sent
      final index = messages.indexWhere((m) => m.id == optimisticMessage.id);
      if (index != -1) {
        messages[index] = optimisticMessage.copyWith(status: MessageStatus.sent);
        messages.refresh();
      }
    } else {
      // Mark as failed
      final index = messages.indexWhere((m) => m.id == optimisticMessage.id);
      if (index != -1) {
        messages[index] = optimisticMessage.copyWith(status: MessageStatus.failed);
        messages.refresh();
        errorMessage.value = 'Failed to send message';
      }
    }
  }

  /// Retry sending a failed message
  Future<void> retryMessage(String messageId) async {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final message = messages[index];
    
    // Update status to sending
    messages[index] = message.copyWith(status: MessageStatus.sending);
    messages.refresh();

    // Retry sending
    final success = await _webSocketService.sendMessage(
      message.content,
      type: message.type,
    );

    if (success) {
      messages[index] = message.copyWith(status: MessageStatus.sent);
    } else {
      messages[index] = message.copyWith(status: MessageStatus.failed);
    }
    messages.refresh();
  }

  /// Manually reconnect
  Future<void> reconnect() async {
    errorMessage.value = '';
    await _webSocketService.reconnect();
  }

  /// Disconnect WebSocket
  void disconnect() {
    _webSocketService.disconnect();
  }

  /// Clear all messages
  void clearMessages() {
    messages.clear();
  }

  /// Load more messages (for pagination)
  Future<void> loadMoreMessages() async {
    if (!hasMoreMessages.value || isLoading.value) return;
    
    // TODO: Implement pagination logic with backend
    Log.d('[ChatController] Load more messages requested');
  }

  /// Scroll to bottom of message list
  void _scrollToBottom() {
    // Delay to allow UI to update
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Cleanup resources
  void _cleanup() {
    _messageSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _errorSubscription?.cancel();
    _webSocketService.disconnect();
    messageController.dispose();
    scrollController.dispose();
  }

  /// Get connection status text
  String get connectionStatusText {
    switch (connectionState.value) {
      case WsConnectionState.connected:
        return 'Connected';
      case WsConnectionState.connecting:
        return 'Connecting...';
      case WsConnectionState.reconnecting:
        return 'Reconnecting...';
      case WsConnectionState.disconnected:
        return 'Disconnected';
      case WsConnectionState.error:
        return 'Connection Error';
    }
  }

  /// Get connection status color
  Color get connectionStatusColor {
    switch (connectionState.value) {
      case WsConnectionState.connected:
        return Colors.green;
      case WsConnectionState.connecting:
      case WsConnectionState.reconnecting:
        return Colors.orange;
      case WsConnectionState.disconnected:
      case WsConnectionState.error:
        return Colors.red;
    }
  }
}
