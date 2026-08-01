import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/student.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({required this.student, super.key});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.school_outlined,
              label: AppStrings.authEcoleLabel,
              value: student.ecole,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            _InfoRow(
              icon: Icons.menu_book_outlined,
              label: AppStrings.authFiliereLabel,
              value: student.filiere,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            _InfoRow(
              icon: Icons.bar_chart_outlined,
              label: AppStrings.authNiveauLabel,
              value: student.niveau,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceSm),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppDimensions.spaceMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(
                value,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
