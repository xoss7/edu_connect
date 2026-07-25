import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/comment_providers.dart';
import '../providers/feed_providers.dart';
import '../widgets/comment_tile.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({required this.postId, super.key});

  final String postId;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final texte = _commentController.text.trim();
    if (texte.isEmpty) return;
    ref
        .read(addCommentControllerProvider.notifier)
        .submit(postId: widget.postId, texte: texte);
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postProvider(widget.postId));
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    ref.listen<AsyncValue<void>>(addCommentControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.postDetailTitle)),
      body: Column(
        children: [
          Expanded(
            child: postAsync.when(
              data: (post) => ListView(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                children: [
                  PostCard(post: post),
                  const SizedBox(height: AppDimensions.spaceMd),
                  commentsAsync.when(
                    data: (comments) => Column(
                      children: comments
                          .map((comment) => CommentTile(comment: comment))
                          .toList(),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        const Text(AppStrings.genericError),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Center(child: Text(AppStrings.genericError)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: AppStrings.commentInputHint,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _submitComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
