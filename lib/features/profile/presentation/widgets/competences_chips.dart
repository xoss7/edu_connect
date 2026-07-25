import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class CompetencesChips extends StatelessWidget {
  const CompetencesChips({required this.competences, super.key});

  final List<String> competences;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children: competences
          .map(
            (competence) => Chip(
              label: Text(
                competence,
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              side: BorderSide.none,
            ),
          )
          .toList(),
    );
  }
}
