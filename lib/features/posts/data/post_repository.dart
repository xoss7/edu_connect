import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/comment.dart';
import '../domain/post.dart';
import 'post_model.dart';

class PostRepository {
  PostRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(FirestorePaths.posts);

  CollectionReference<Map<String, dynamic>> _comments(String postId) =>
      _posts.doc(postId).collection(FirestorePaths.postComments);

  // No server-side filtering here — école/filière/niveau filters are
  // applied client-side (see feed_providers.dart) since école/filière are
  // free text and an exact Firestore `where` would silently miss any
  // case/spelling difference. Keeping the query to a single orderBy also
  // avoids needing a composite index.
  Stream<List<Post>> watchFeed() {
    return _posts
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(postFromDoc).toList());
  }

  Stream<Post> watchPost(String postId) {
    return _posts.doc(postId).snapshots().map(postFromDoc);
  }

  Future<void> createPost({
    required String auteurId,
    required String texte,
    String? imageUrl,
    required String ecole,
    required String filiere,
    required String niveau,
  }) {
    return _posts.add({
      'auteurId': auteurId,
      'texte': texte,
      'imageUrl': imageUrl,
      'ecole': ecole,
      'filiere': filiere,
      'niveau': niveau,
      'likedBy': <String>[],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> like(String postId, String uid) {
    return _posts.doc(postId).update({
      'likedBy': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> unlike(String postId, String uid) {
    return _posts.doc(postId).update({
      'likedBy': FieldValue.arrayRemove([uid]),
    });
  }

  Stream<List<Comment>> watchComments(String postId) {
    return _comments(postId)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(commentFromDoc).toList());
  }

  Future<void> addComment(
    String postId, {
    required String auteurId,
    required String texte,
  }) {
    return _comments(postId).add({
      'auteurId': auteurId,
      'texte': texte,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(FirebaseFirestore.instance);
});
