import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/student.dart';
import 'competences_chips.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(student.nom, style: AppTextStyles.headline),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(
          [
            student.ecole,
            student.filiere,
            student.niveau,
          ].join(AppStrings.profileFieldSeparator),
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(
          '${AppStrings.profileReputationLabel}${AppStrings.profileFieldSeparator}${student.reputationScore}',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(AppStrings.profileCompetencesLabel, style: AppTextStyles.title),
        const SizedBox(height: AppDimensions.spaceSm),
        CompetencesChips(competences: student.competences),
      ],
    );
  }
}
