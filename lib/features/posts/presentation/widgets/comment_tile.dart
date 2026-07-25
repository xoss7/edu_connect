import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/comment.dart';

class CommentTile extends ConsumerWidget {
  const CommentTile({required this.comment, super.key});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(studentProvider(comment.auteurId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InitialsAvatar(name: authorAsync.value?.nom ?? '', radius: 16),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(authorAsync.value?.nom ?? '', style: AppTextStyles.title),
                Text(comment.texte, style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
