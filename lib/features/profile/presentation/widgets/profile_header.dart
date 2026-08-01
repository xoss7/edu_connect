import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../domain/student.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InitialsAvatar(name: student.nom, radius: 40),
        const SizedBox(height: AppDimensions.spaceMd),
        Text(student.nom, style: AppTextStyles.headline),
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
