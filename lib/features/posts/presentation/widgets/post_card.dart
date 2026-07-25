import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/post_repository.dart';
import '../../domain/post.dart';
import '../providers/comment_providers.dart';

String _formatRelativeTime(DateTime timestamp) {
  final difference = DateTime.now().difference(timestamp);
  if (difference.inMinutes < 1) return AppStrings.timeJustNow;
  if (difference.inHours < 1) {
    return '${difference.inMinutes} ${AppStrings.timeMinutesSuffix}';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours} ${AppStrings.timeHoursSuffix}';
  }
  return '${difference.inDays} ${AppStrings.timeDaysSuffix}';
}

class PostCard extends ConsumerWidget {
  const PostCard({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(studentProvider(post.auteurId));
    final commentsAsync = ref.watch(commentsProvider(post.id));
    final currentUid = ref.watch(authServiceProvider).currentUser!.uid;
    final isLiked = post.isLikedBy(currentUid);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push('${AppRoutes.feed}/${post.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialsAvatar(
                    name: authorAsync.value?.nom ?? '',
                    radius: 20,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorAsync.value?.nom ?? '',
                          style: AppTextStyles.title,
                        ),
                        Text(
                          _formatRelativeTime(post.timestamp),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(post.texte, style: AppTextStyles.body),
              if (post.imageUrl != null) ...[
                const SizedBox(height: AppDimensions.spaceSm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: Image.network(
                    post.imageUrl!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spaceSm),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppColors.like : null,
                    ),
                    onPressed: () {
                      final repository = ref.read(postRepositoryProvider);
                      if (isLiked) {
                        repository.unlike(post.id, currentUid);
                      } else {
                        repository.like(post.id, currentUid);
                      }
                    },
                  ),
                  Text('${post.likesCount}', style: AppTextStyles.body),
                  const SizedBox(width: AppDimensions.spaceMd),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () =>
                        context.push('${AppRoutes.feed}/${post.id}'),
                  ),
                  Text(
                    '${commentsAsync.value?.length ?? 0}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
