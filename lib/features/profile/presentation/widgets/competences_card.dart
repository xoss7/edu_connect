import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'competences_chips.dart';

class CompetencesCard extends StatelessWidget {
  const CompetencesCard({required this.competences, super.key});

  final List<String> competences;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.profileCompetencesLabel,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            if (competences.isEmpty)
              Text(
                AppStrings.profileNoCompetences,
                style: AppTextStyles.subtitle,
              )
            else
              CompetencesChips(competences: competences),
          ],
        ),
      ),
    );
  }
}
