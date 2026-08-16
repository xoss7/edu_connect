import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/comment.dart';
import '../domain/post.dart';
import 'post_model.dart';

class PostRepository {
  PostRepository(this._supabase);

  final SupabaseClient _supabase;

  Stream<List<Post>> watchFeed() {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(50)
        .map((data) => data.map(postFromMap).toList());
  }

  Stream<Post> watchPost(String postId) {
    return _supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .eq('id', postId)
        .map((data) => postFromMap(data.first));
  }

  Future<void> createPost({
    required String auteurId,
    required String texte,
    String? imageUrl,
    required String ecole,
    required String filiere,
    required String niveau,
  }) async {
    await _supabase.from('posts').insert({
      'auteur_id': auteurId,
      'texte': texte,
      'image_url': imageUrl,
      'ecole': ecole,
      'filiere': filiere,
      'niveau': niveau,
    });
  }

  Future<void> like(String postId, String uid) async {
    // In SQL, we handle array union differently
    final post = await _supabase.from('posts').select('liked_by').eq('id', postId).single();
    final likedBy = List<String>.from(post['liked_by'] as List);
    if (!likedBy.contains(uid)) {
      likedBy.add(uid);
      await _supabase.from('posts').update({'liked_by': likedBy}).eq('id', postId);
    }
  }

  Future<void> unlike(String postId, String uid) async {
    final post = await _supabase.from('posts').select('liked_by').eq('id', postId).single();
    final likedBy = List<String>.from(post['liked_by'] as List);
    if (likedBy.contains(uid)) {
      likedBy.remove(uid);
      await _supabase.from('posts').update({'liked_by': likedBy}).eq('id', postId);
    }
  }

  Stream<List<Comment>> watchComments(String postId) {
    return _supabase
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true)
        .map((data) => data.map(commentFromMap).toList());
  }

  Future<void> addComment(
    String postId, {
    required String auteurId,
    required String texte,
  }) async {
    await _supabase.from('comments').insert({
      'post_id': postId,
      'auteur_id': auteurId,
      'texte': texte,
    });
  }
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(Supabase.instance.client);
});
