class Conversation {
  const Conversation({
    required this.id,
    required this.participantOneId,
    required this.participantTwoId,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  final String id;
  final String participantOneId;
  final String participantTwoId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  String otherParticipantId(String currentUid) =>
      currentUid == participantOneId ? participantTwoId : participantOneId;

  bool hasParticipant(String uid) =>
      uid == participantOneId || uid == participantTwoId;
}
