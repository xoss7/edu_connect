import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/post_repository.dart';
import '../../domain/comment.dart';

// .family memoizes by postId, so the feed tile's live comment count and the
// detail screen's full comment list share a single subscription when both
// are mounted for the same post.
final commentsProvider = StreamProvider.family<List<Comment>, String>((
  ref,
  postId,
) {
  return ref.watch(postRepositoryProvider).watchComments(postId);
});

class AddCommentController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String postId, required String texte}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;
      await ref
          .read(postRepositoryProvider)
          .addComment(postId, auteurId: uid, texte: texte);
    });
  }
}

final addCommentControllerProvider =
    AsyncNotifierProvider<AddCommentController, void>(AddCommentController.new);
