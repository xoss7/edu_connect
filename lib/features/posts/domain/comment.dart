class Comment {
  const Comment({
    required this.id,
    required this.auteurId,
    required this.texte,
    required this.timestamp,
  });

  final String id;
  final String auteurId;
  final String texte;
  final DateTime timestamp;
}
