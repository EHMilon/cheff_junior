import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../../shared/utils/looger_utills.dart';
import '../models/chat_message_model.dart';
import 'api_constant.dart';

/// WebSocket Service for real-time chat communication
/// Features:
/// - Automatic connection management
/// - Exponential backoff reconnect logic
/// - Message stream handling
/// - Connection state management
class WebSocketService {
  // Singleton pattern
  WebSocketService._();
  static final WebSocketService _instance = WebSocketService._();
  static WebSocketService get instance => _instance;

  // Configuration constants
  static const Duration _initialReconnectDelay = Duration(seconds: 1);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);
  static const int _maxReconnectAttempts = 10;

  // WebSocket channel
  WebSocketChannel? _channel;

  // Connection management
  String? _userId;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  Duration _currentReconnectDelay = _initialReconnectDelay;
  bool _isDisposed = false;
  bool _shouldReconnect = true;

  // Stream controllers
  final StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  final StreamController<WsConnectionState> _connectionStateController =
      StreamController<WsConnectionState>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Public streams
  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<WsConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<String> get errorStream => _errorController.stream;

  // Current state
  WsConnectionState _currentState = WsConnectionState.disconnected;
  WsConnectionState get currentState => _currentState;

  bool get isConnected => _currentState == WsConnectionState.connected;
  bool get isConnecting => _currentState == WsConnectionState.connecting;

  // Callbacks for lifecycle events
  void Function()? onConnected;
  void Function()? onDisconnected;
  void Function(String error)? onError;
  void Function(ChatMessage message)? onMessageReceived;

  /// Initialize and connect to WebSocket
  /// [userId] - The user ID for the chat endpoint
  Future<void> connect(String userId) async {
    if (_isDisposed) {
      Log.w('[WebSocket] Cannot connect: service is disposed');
      return;
    }

    if (_currentState == WsConnectionState.connected ||
        _currentState == WsConnectionState.connecting) {
      Log.w('[WebSocket] Already connected or connecting');
      return;
    }

    _userId = userId;
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    _currentReconnectDelay = _initialReconnectDelay;

    await _establishConnection();
  }

  /// Establish WebSocket connection
  Future<void> _establishConnection() async {
    if (_isDisposed || _userId == null) return;

    _updateState(WsConnectionState.connecting);

    try {
      final wsUrl = ApiConstants.chatWebSocketUrl(_userId!);
      Log.i('[WebSocket] Connecting to: $wsUrl');

      // Create WebSocket connection with timeout
      final webSocket = await WebSocket.connect(wsUrl, headers: _getHeaders())
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException('Connection timeout');
            },
          );

      _channel = IOWebSocketChannel(webSocket);

      // Listen to incoming messages
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onConnectionClosed,
        cancelOnError: false,
      );

      _updateState(WsConnectionState.connected);
      _reconnectAttempts = 0;
      _currentReconnectDelay = _initialReconnectDelay;

      onConnected?.call();
      Log.i('[WebSocket] Connected successfully');
    } on SocketException catch (e) {
      Log.e('[WebSocket] SocketException: ${e.message}');
      _handleConnectionError('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      Log.e('[WebSocket] TimeoutException: ${e.message}');
      _handleConnectionError('Connection timeout');
    } catch (e, stackTrace) {
      Log.e('[WebSocket] Connection error: $e\n$stackTrace');
      _handleConnectionError('Connection failed: $e');
    }
  }

  /// Get headers for WebSocket connection
  Map<String, dynamic> _getHeaders() {
    // Add any authentication headers if needed
    return {'Content-Type': 'application/json'};
  }

  /// Handle incoming messages
  void _onMessage(dynamic data) {
    try {
      Log.d('[WebSocket] Received: $data');

      // Try to parse as JSON first
      if (data is String && data.trim().startsWith('{')) {
        final Map<String, dynamic> json = jsonDecode(data);
        final message = ChatMessage.fromJson(json);
        _messageController.add(message);
        onMessageReceived?.call(message);
      } else {
        // Handle plain text messages from server
        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'server', // Server/AI sender
          content: data.toString(),
          timestamp: DateTime.now(),
          type: MessageType.text,
          status: MessageStatus.sent,
        );
        _messageController.add(message);
        onMessageReceived?.call(message);
      }
    } catch (e, stackTrace) {
      Log.e('[WebSocket] Error parsing message: $e\n$stackTrace');
      // Try to handle as plain text even if parsing failed
      if (data is String) {
        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'server',
          content: data,
          timestamp: DateTime.now(),
          type: MessageType.text,
          status: MessageStatus.sent,
        );
        _messageController.add(message);
        onMessageReceived?.call(message);
      }
    }
  }

  /// Handle WebSocket errors
  void _onError(dynamic error) {
    Log.e('[WebSocket] Error: $error');
    _errorController.add(error.toString());
    onError?.call(error.toString());
  }

  /// Handle connection close
  void _onConnectionClosed() {
    Log.w('[WebSocket] Connection closed');
    onDisconnected?.call();

    if (_shouldReconnect && !_isDisposed) {
      _scheduleReconnect();
    } else {
      _updateState(WsConnectionState.disconnected);
    }
  }

  /// Handle connection errors with reconnect logic
  void _handleConnectionError(String error) {
    _errorController.add(error);
    onError?.call(error);

    if (_shouldReconnect && !_isDisposed) {
      _scheduleReconnect();
    } else {
      _updateState(WsConnectionState.error);
    }
  }

  /// Schedule reconnection with exponential backoff
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      Log.e('[WebSocket] Max reconnect attempts reached');
      _updateState(WsConnectionState.error);
      _errorController.add(
        'Max reconnect attempts reached. Please try again later.',
      );
      return;
    }

    _reconnectAttempts++;
    _updateState(WsConnectionState.reconnecting);

    Log.i(
      '[WebSocket] Reconnecting in ${_currentReconnectDelay.inSeconds}s '
      '(attempt $_reconnectAttempts/$_maxReconnectAttempts)',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_currentReconnectDelay, () {
      if (!_isDisposed && _shouldReconnect) {
        _establishConnection();
      }
    });

    // Exponential backoff: double the delay up to max
    _currentReconnectDelay = Duration(
      seconds: (_currentReconnectDelay.inSeconds * 2).clamp(
        _initialReconnectDelay.inSeconds,
        _maxReconnectDelay.inSeconds,
      ),
    );
  }



  /// Send message to server
  Future<bool> sendMessage(
    String content, {
    MessageType type = MessageType.text,
  }) async {
    if (!isConnected) {
      Log.w('[WebSocket] Cannot send message: not connected');
      return false;
    }

    try {
      final message = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': _userId,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
        'type': type.value,
      };

      _channel?.sink.add(jsonEncode(message));
      Log.i('[WebSocket] Message sent: $content');
      return true;
    } catch (e, stackTrace) {
      Log.e('[WebSocket] Error sending message: $e\n$stackTrace');
      return false;
    }
  }

  /// Send custom JSON data
  Future<bool> sendJson(Map<String, dynamic> data) async {
    if (!isConnected) {
      Log.w('[WebSocket] Cannot send JSON: not connected');
      return false;
    }

    try {
      _channel?.sink.add(jsonEncode(data));
      return true;
    } catch (e) {
      Log.e('[WebSocket] Error sending JSON: $e');
      return false;
    }
  }

  /// Disconnect WebSocket (temporary - will not auto-reconnect)
  void disconnect() {
    Log.i('[WebSocket] Disconnecting...');
    _shouldReconnect = false;
    _cleanup();
    _updateState(WsConnectionState.disconnected);
  }

  /// Reconnect WebSocket manually
  Future<void> reconnect() async {
    Log.i('[WebSocket] Manual reconnect...');
    disconnect();
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    _currentReconnectDelay = _initialReconnectDelay;

    if (_userId != null) {
      await connect(_userId!);
    }
  }

  /// Dispose the service permanently
  void dispose() {
    Log.i('[WebSocket] Disposing service...');
    _isDisposed = true;
    _shouldReconnect = false;
    _cleanup();
    _messageController.close();
    _connectionStateController.close();
    _errorController.close();
  }

  /// Cleanup resources
  void _cleanup() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      _channel?.sink.close();
    } catch (e) {
      Log.w('[WebSocket] Error closing channel: $e');
    }
    _channel = null;
  }

  /// Update connection state and notify listeners
  void _updateState(WsConnectionState state) {
    if (_currentState != state) {
      _currentState = state;
      _connectionStateController.add(state);
      Log.i('[WebSocket] State changed: $state');
    }
  }
}

/// Custom timeout exception
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
