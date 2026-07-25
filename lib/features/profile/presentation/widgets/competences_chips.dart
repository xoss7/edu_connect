import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';

class CompetencesChips extends StatelessWidget {
  const CompetencesChips({required this.competences, super.key});

  final List<String> competences;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceSm,
      runSpacing: AppDimensions.spaceSm,
      children: competences
          .map((competence) => Chip(label: Text(competence)))
          .toList(),
    );
  }
}
