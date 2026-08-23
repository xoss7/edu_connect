import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/animated_pressable.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    required this.title,
    required this.onTap,
    this.icon,
    this.assetPath,
    this.isLarge = false,
    super.key,
  });

  final String title;
  final IconData? icon;
  final String? assetPath;
  final VoidCallback onTap;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.12),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded (rather than a fixed-height SizedBox) lets the image
            // area shrink to whatever height the grid cell actually has on
            // a given screen, instead of overflowing on narrower phones.
            Expanded(
              child: Center(
                child: assetPath != null
                    ? Image.asset(assetPath!, fit: BoxFit.contain)
                    : Icon(
                        icon,
                        color: AppColors.primary,
                        size: isLarge ? 80 : 56,
                      ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              title,
              style: AppTextStyles.title.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isLarge ? 20 : 16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
