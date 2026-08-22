class Message {
  const Message({
    required this.id,
    required this.conversationId,
    required this.auteurId,
    required this.texte,
    required this.timestamp,
  });

  final String id;
  final String conversationId;
  final String auteurId;
  final String texte;
  final DateTime timestamp;
}
