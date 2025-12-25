class Chat {
  final String id;
  final String participantId;
  final String participantName;
  final String? participantImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isRead;
  final String participantType; // 'founder' or 'startup'

  Chat({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isRead,
    required this.participantType,
  });

  Chat copyWith({
    String? id,
    String? participantId,
    String? participantName,
    String? participantImage,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? isRead,
    String? participantType,
  }) {
    return Chat(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      participantImage: participantImage ?? this.participantImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isRead: isRead ?? this.isRead,
      participantType: participantType ?? this.participantType,
    );
  }
}