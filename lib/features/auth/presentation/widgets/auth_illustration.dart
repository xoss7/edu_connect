import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Placeholder illustration shown at the top of the auth screens, standing
/// in for the real artwork until image assets are added under
/// `assets/images/`.
class AuthIllustration extends StatelessWidget {
  const AuthIllustration({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppDimensions.illustrationSize,
        height: AppDimensions.illustrationSize,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: AppDimensions.illustrationIconSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
