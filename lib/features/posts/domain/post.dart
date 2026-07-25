class Post {
  const Post({
    required this.id,
    required this.auteurId,
    required this.texte,
    this.imageUrl,
    required this.ecole,
    required this.filiere,
    required this.niveau,
    required this.timestamp,
    this.likedBy = const [],
  });

  final String id;
  final String auteurId;
  final String texte;
  final String? imageUrl;
  final String ecole;
  final String filiere;
  final String niveau;
  final DateTime timestamp;
  final List<String> likedBy;

  int get likesCount => likedBy.length;

  bool isLikedBy(String uid) => likedBy.contains(uid);
}
