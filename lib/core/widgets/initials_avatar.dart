import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({required this.name, required this.radius, super.key});

  final String name;
  final double radius;

  String get _initials {
    final words = name.trim().split(RegExp(r'\s+'));
    final letters = words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase());
    return letters.join();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        _initials,
        style: AppTextStyles.headline.copyWith(
          color: AppColors.onPrimary,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}
