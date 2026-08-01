class Resource {
  const Resource({
    required this.id,
    required this.titre,
    required this.matiere,
    required this.ecole,
    required this.niveau,
    required this.fileUrl,
    required this.uploaderId,
    required this.downloads,
    required this.timestamp,
  });

  final String id;
  final String titre;
  final String matiere;
  final String ecole;
  final String niveau;
  final String fileUrl;
  final String uploaderId;
  final int downloads;
  final DateTime timestamp;
}
