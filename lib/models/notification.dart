enum NotificationType {
  connectionRequest,
  connectionAccepted,
  message,
  startupUpdate,
  general,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedId;
  final String? senderName;
  final String? senderImage;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedId,
    this.senderName,
    this.senderImage,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      relatedId: json['relatedId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'relatedId': relatedId,
      'senderName': senderName,
      'senderImage': senderImage,
    };
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId,
      senderName: senderName,
      senderImage: senderImage,
    );
  }
}