/// Chat Message Model
/// Represents a single chat message in the WebSocket communication
class ChatMessage {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;

  ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      content: json['content'] ?? json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: MessageType.fromString(json['type'] ?? 'text'),
      status: MessageStatus.fromString(json['status'] ?? 'sent'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.value,
      'status': status.value,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}

/// Enum for message types
enum MessageType {
  text('text'),
  image('image'),
  system('system');

  final String value;
  const MessageType(this.value);

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageType.text,
    );
  }
}

/// Enum for message status
enum MessageStatus {
  sending('sending'),
  sent('sent'),
  delivered('delivered'),
  read('read'),
  failed('failed');

  final String value;
  const MessageStatus(this.value);

  static MessageStatus fromString(String value) {
    return MessageStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageStatus.sent,
    );
  }
}

/// WebSocket connection state
enum WsConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}
