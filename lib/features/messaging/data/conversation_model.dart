import '../domain/conversation.dart';
import '../domain/message.dart';

Conversation conversationFromMap(Map<String, dynamic> data) {
  return Conversation(
    id: data['id'] as String,
    participantOneId: data['participant_one_id'] as String,
    participantTwoId: data['participant_two_id'] as String,
    lastMessage: data['last_message'] as String?,
    lastMessageAt: data['last_message_at'] != null
        ? DateTime.parse(data['last_message_at'] as String)
        : null,
    createdAt: DateTime.parse(data['created_at'] as String),
  );
}

Message messageFromMap(Map<String, dynamic> data) {
  return Message(
    id: data['id'] as String,
    conversationId: data['conversation_id'] as String,
    auteurId: data['auteur_id'] as String,
    texte: data['texte'] as String,
    timestamp: DateTime.parse(data['created_at'] as String),
  );
}
