import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
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
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
            InitialsAvatar(
              name: student.nom,
              radius: 44,
              // Assuming InitialsAvatar allows color/style customization, 
              // otherwise the Stack gives a nice border effect.
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceLg),
        Text(
          student.nom,
          style: AppTextStyles.headline.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: student.reputationScore.toDouble()),
          duration: const Duration(seconds: 1),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceLg,
                vertical: AppDimensions.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 20),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Text(
                    '${value.toInt()} Points',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
