import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/conversation.dart';

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

class ConversationTile extends ConsumerWidget {
  const ConversationTile({
    required this.conversation,
    required this.currentUid,
    required this.onTap,
    super.key,
  });

  final Conversation conversation;
  final String currentUid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherId = conversation.otherParticipantId(currentUid);
    final otherAsync = ref.watch(studentProvider(otherId));
    final otherName = otherAsync.value?.nom ?? '';

    return ListTile(
      onTap: onTap,
      leading: InitialsAvatar(name: otherName, radius: 22),
      title: Text(otherName, style: AppTextStyles.title),
      subtitle: Text(
        conversation.lastMessage ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body,
      ),
      trailing: conversation.lastMessageAt != null
          ? Text(
              _formatRelativeTime(conversation.lastMessageAt!),
              style: AppTextStyles.caption,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceXs,
      ),
    );
  }
}
