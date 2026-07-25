import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/student.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.student, super.key});

  final Student student;

  String get _initials {
    final words = student.nom.trim().split(RegExp(r'\s+'));
    final letters = words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase());
    return letters.join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary,
          child: Text(
            _initials,
            style: AppTextStyles.headline.copyWith(color: AppColors.onPrimary),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(student.nom, style: AppTextStyles.headline),
        const SizedBox(height: AppDimensions.spaceXs),
        Text(
          [
            student.ecole,
            student.filiere,
            student.niveau,
          ].join(AppStrings.profileFieldSeparator),
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: AppColors.secondary, size: 18),
              const SizedBox(width: AppDimensions.spaceXs),
              Text(
                '${student.reputationScore}'
                '${AppStrings.profileFieldSeparator}'
                '${AppStrings.profileReputationLabel}',
                style: AppTextStyles.title.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
