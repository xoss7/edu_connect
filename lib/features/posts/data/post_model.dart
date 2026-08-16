import '../domain/comment.dart';
import '../domain/post.dart';

Post postFromMap(Map<String, dynamic> data) {
  return Post(
    id: data['id'] as String,
    auteurId: data['auteur_id'] as String,
    texte: data['texte'] as String,
    imageUrl: data['image_url'] as String?,
    ecole: data['ecole'] as String,
    filiere: data['filiere'] as String,
    niveau: data['niveau'] as String,
    timestamp: DateTime.parse(data['created_at'] as String),
    likedBy: List<String>.from(data['liked_by'] as List? ?? const []),
  );
}

Comment commentFromMap(Map<String, dynamic> data) {
  return Comment(
    id: data['id'] as String,
    auteurId: data['auteur_id'] as String,
    texte: data['texte'] as String,
    timestamp: DateTime.parse(data['created_at'] as String),
  );
}
