import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class SkillChip extends StatelessWidget {
  const SkillChip({required this.label, this.isSelected = false, super.key});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
