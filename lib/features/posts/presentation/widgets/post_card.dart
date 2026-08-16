import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/animated_pressable.dart';
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
    final currentUid = ref.watch(authServiceProvider).currentUser!.id;
    final isLiked = post.isLikedBy(currentUid);

    return AnimatedPressable(
      onTap: () => context.push('${AppRoutes.feed}/${post.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppColors.softShadow,
          border: Border.all(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
          ),
        ),
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
                          style: AppTextStyles.title.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatRelativeTime(post.timestamp),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.more_horiz,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                post.texte,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              if (post.imageUrl != null) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.surfaceVariant,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.spaceMd),
              const Divider(height: 1, thickness: 0.5),
              const SizedBox(height: AppDimensions.spaceSm),
              Row(
                children: [
                  _ActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '${post.likesCount}',
                    color: isLiked ? AppColors.like : AppColors.textSecondary,
                    onTap: () {
                      final repository = ref.read(postRepositoryProvider);
                      if (isLiked) {
                        repository.unlike(post.id, currentUid);
                      } else {
                        repository.like(post.id, currentUid);
                      }
                    },
                  ),
                  const SizedBox(width: AppDimensions.spaceMd),
                  _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: '${commentsAsync.value?.length ?? 0}',
                    color: AppColors.textSecondary,
                    onTap: () => context.push('${AppRoutes.feed}/${post.id}'),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceSm,
          vertical: AppDimensions.spaceXs,
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(icon, key: ValueKey(icon), color: color, size: 20),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
