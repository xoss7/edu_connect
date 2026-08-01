import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../quizzes/domain/quiz_attempt.dart';
import '../../../quizzes/presentation/providers/quiz_providers.dart';

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

class QuizAttemptsCard extends ConsumerWidget {
  const QuizAttemptsCard({required this.uid, super.key});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attemptsAsync = ref.watch(quizAttemptsProvider(uid));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.quizAttemptsHistoryTitle,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            attemptsAsync.when(
              data: (attempts) => attempts.isEmpty
                  ? Text(
                      AppStrings.quizAttemptsEmptyMessage,
                      style: AppTextStyles.subtitle,
                    )
                  : Column(
                      children: attempts
                          .map((attempt) => _AttemptRow(attempt: attempt))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const Text(AppStrings.genericError),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt});

  final QuizAttempt attempt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Row(
        children: [
          Expanded(child: Text(attempt.quizTitre, style: AppTextStyles.body)),
          Text(
            '${attempt.score}/${attempt.totalQuestions}',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppDimensions.spaceMd),
          Text(
            _formatRelativeTime(attempt.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
