import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/comment.dart';
import '../domain/post.dart';

// Falls back to DateTime.now() for the brief window right after creation
// where FieldValue.serverTimestamp() hasn't resolved server-side yet and
// the field reads back as null.
Post postFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Post(
    id: doc.id,
    auteurId: data['auteurId'] as String,
    texte: data['texte'] as String,
    imageUrl: data['imageUrl'] as String?,
    ecole: data['ecole'] as String,
    filiere: data['filiere'] as String,
    niveau: data['niveau'] as String,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    likedBy: List<String>.from(data['likedBy'] as List? ?? const []),
  );
}

Comment commentFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Comment(
    id: doc.id,
    auteurId: data['auteurId'] as String,
    texte: data['texte'] as String,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
