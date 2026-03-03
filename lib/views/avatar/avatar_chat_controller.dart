import 'dart:async';
import 'package:chef_junior/core/themes/app_colors.dart';
import 'package:chef_junior/data/models/chat_message_model.dart';
import 'package:chef_junior/data/services/auth_service.dart';
import 'package:chef_junior/data/services/websocket_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// Message Model for UI display
class MessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;

  MessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  factory MessageModel.fromChatMessage(ChatMessage message, String currentUserId) {
    return MessageModel(
      id: message.id,
      text: message.content,
      isUser: message.userId == currentUserId,
      timestamp: message.timestamp,
      status: message.status,
    );
  }
}

/// Avatar Chat Controller with WebSocket integration
/// Features:
/// - Real-time messaging via WebSocket
/// - Heartbeat keep-alive every 30s
/// - Auto-reconnect with exponential backoff
/// - Connection state management
/// - Proper lifecycle handling
class AvatarChatController extends GetxController with WidgetsBindingObserver {
  final Logger _logger = Logger();
  final Connectivity _connectivity = Connectivity();
  final WebSocketService _webSocketService = WebSocketService.instance;
  final AuthService _authService = Get.find<AuthService>();

  // Connectivity
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription<WsConnectionState>? _connectionStateSubscription;
  StreamSubscription<String>? _errorSubscription;

  // Observable state
  final RxBool isOnline = true.obs;
  final RxBool isLoading = true.obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool showInitialState = true.obs;
  final Rx<WsConnectionState> connectionState = WsConnectionState.disconnected.obs;
  final RxString errorMessage = ''.obs;

  // Pending message when offline
  String? _pendingMessage;

  // Controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Recommended topics
  final List<String> recommendedTopics = [
    "How to cook chicken fry?",
    "Can you give me the recipe of french fries?",
  ];

  // Get current user ID from SharedPreferences (more reliable than currentUser)
  String? get currentUserId {
    // First try to get from currentUser model
    final userId = _authService.currentUser?.id;
    if (userId != null && userId.isNotEmpty) {
      return userId;
    }
    // Fallback to SharedPreferences
    return _authService.getUserId();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    _initializeWebSocket();
    _loadInitialData();
  }

  @override
  void onReady() {
    super.onReady();
    _connectWebSocket();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    _messageSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _errorSubscription?.cancel();
    _webSocketService.disconnect();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _logger.i('[AvatarChatController] App resumed, connecting WebSocket');
        _connectWebSocket();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _logger.i('[AvatarChatController] App backgrounded, disconnecting WebSocket');
        _webSocketService.disconnect();
        break;
      case AppLifecycleState.detached:
        _webSocketService.disconnect();
        break;
    }
  }

  /// Initialize WebSocket listeners
  void _initializeWebSocket() {
    // Listen to incoming messages
    _messageSubscription = _webSocketService.messageStream.listen(
      _onMessageReceived,
      onError: (error) {
        _logger.e('[AvatarChatController] Message stream error: $error');
      },
    );

    // Listen to connection state changes
    _connectionStateSubscription = _webSocketService.connectionStateStream.listen(
      (state) {
        connectionState.value = state;
        _logger.i('[AvatarChatController] Connection state: $state');
      },
      onError: (error) {
        _logger.e('[AvatarChatController] Connection state stream error: $error');
      },
    );

    // Listen to errors
    _errorSubscription = _webSocketService.errorStream.listen(
      (error) {
        errorMessage.value = error;
        _logger.e('[AvatarChatController] WebSocket error: $error');
      },
      onError: (error) {
        _logger.e('[AvatarChatController] Error stream error: $error');
      },
    );
  }

  /// Connect to WebSocket
  Future<void> _connectWebSocket() async {
    if (currentUserId == null) {
      _logger.w('[AvatarChatController] Cannot connect: no user ID');
      errorMessage.value = 'Please login to use chat';
      return;
    }

    if (_webSocketService.isConnected || _webSocketService.isConnecting) {
      return;
    }

    try {
      await _webSocketService.connect(currentUserId!);
    } catch (e) {
      _logger.e('[AvatarChatController] Connection error: $e');
      errorMessage.value = 'Failed to connect: $e';
    }
  }

  /// Handle incoming message from WebSocket
  void _onMessageReceived(ChatMessage message) {
    isTyping.value = false;
    
    final messageModel = MessageModel.fromChatMessage(
      message,
      currentUserId ?? 'unknown',
    );
    
    messages.add(messageModel);
    showInitialState.value = false;
    _scrollToBottom();
    
    _logger.i('[AvatarChatController] Message received: ${message.content}');
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool previouslyOffline = !isOnline.value;
    isOnline.value = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    _logger.i("Connectivity status updated: ${isOnline.value}");

    if (isOnline.value && previouslyOffline && _pendingMessage != null) {
      _logger.i("Back online, sending pending message");
      _sendToServer(_pendingMessage!);
      _pendingMessage = null;
    }
  }

  void sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (!isOnline.value) {
      _pendingMessage = text;
      Get.snackbar(
        "offline".tr,
        "offline_msg".tr,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_webSocketService.isConnected) {
      errorMessage.value = 'Not connected to chat server';
      // Try to reconnect
      await _connectWebSocket();
      if (!_webSocketService.isConnected) {
        Get.snackbar(
          "error".tr,
          "Unable to connect to chat server. Please try again.".tr,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    _sendToServer(text);
  }

  void _sendToServer(String text) async {
    // Clear and hide initial state
    messageController.clear();
    showInitialState.value = false;

    // Create optimistic user message
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    // Add to UI immediately
    messages.add(userMessage);
    _scrollToBottom();

    // Send via WebSocket
    final success = await _webSocketService.sendMessage(text);

    if (success) {
      // Update status to sent
      final index = messages.indexWhere((m) => m.id == userMessage.id);
      if (index != -1) {
        messages[index] = MessageModel(
          id: userMessage.id,
          text: userMessage.text,
          isUser: true,
          timestamp: userMessage.timestamp,
          status: MessageStatus.sent,
        );
        messages.refresh();
      }
      
      // Show typing indicator while waiting for server response
      isTyping.value = true;
    } else {
      // Mark as failed
      final index = messages.indexWhere((m) => m.id == userMessage.id);
      if (index != -1) {
        messages[index] = MessageModel(
          id: userMessage.id,
          text: userMessage.text,
          isUser: true,
          timestamp: userMessage.timestamp,
          status: MessageStatus.failed,
        );
        messages.refresh();
      }
      
      errorMessage.value = 'Failed to send message';
      Get.snackbar(
        "error".tr,
        "Failed to send message. Please try again.".tr,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Retry sending a failed message
  Future<void> retryMessage(String messageId) async {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final message = messages[index];
    if (!message.isUser) return;

    // Update status to sending
    messages[index] = MessageModel(
      id: message.id,
      text: message.text,
      isUser: message.isUser,
      timestamp: message.timestamp,
      status: MessageStatus.sending,
    );
    messages.refresh();

    // Retry sending
    final success = await _webSocketService.sendMessage(message.text);

    if (success) {
      messages[index] = MessageModel(
        id: message.id,
        text: message.text,
        isUser: message.isUser,
        timestamp: message.timestamp,
        status: MessageStatus.sent,
      );
    } else {
      messages[index] = MessageModel(
        id: message.id,
        text: message.text,
        isUser: message.isUser,
        timestamp: message.timestamp,
        status: MessageStatus.failed,
      );
    }
    messages.refresh();
  }

  /// Manually reconnect
  Future<void> reconnect() async {
    errorMessage.value = '';
    await _webSocketService.reconnect();
  }

  void selectTopic(String topic) {
    messageController.text = topic;
    sendMessage();
  }

  void _scrollToBottom() {
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

  /// Get connection status text for UI
  String get connectionStatusText {
    switch (connectionState.value) {
      case WsConnectionState.connected:
        return 'online'.tr;
      case WsConnectionState.connecting:
        return 'connecting'.tr;
      case WsConnectionState.reconnecting:
        return 'reconnecting'.tr;
      case WsConnectionState.disconnected:
        return 'offline'.tr;
      case WsConnectionState.error:
        return 'connection_error'.tr;
    }
  }

  /// Get connection status color for UI
  Color get connectionStatusColor {
    switch (connectionState.value) {
      case WsConnectionState.connected:
        return AppColors.success;
      case WsConnectionState.connecting:
      case WsConnectionState.reconnecting:
        return Colors.orange;
      case WsConnectionState.disconnected:
      case WsConnectionState.error:
        return AppColors.error;
    }
  }

  /// Check if WebSocket is connected
  bool get isWebSocketConnected => _webSocketService.isConnected;
}
