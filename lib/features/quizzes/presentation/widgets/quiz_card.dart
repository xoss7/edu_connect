import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/quiz.dart';

class QuizCard extends ConsumerWidget {
  const QuizCard({required this.quiz, super.key});

  final Quiz quiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createurAsync = ref.watch(studentProvider(quiz.createurId));

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push('${AppRoutes.quizzes}/${quiz.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quiz.titre, style: AppTextStyles.title),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                createurAsync.value?.nom ?? '',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Row(
                children: [
                  Chip(
                    label: Text(
                      quiz.matiere,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Text(
                    '${quiz.questions.length}'
                    ' ${AppStrings.quizQuestionsCountLabel}',
                    style: AppTextStyles.caption,
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
