import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({required this.assetPath, super.key});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        assetPath,
        width: AppDimensions.illustrationSize,
        height: AppDimensions.illustrationSize,
        fit: BoxFit.contain,
      ),
    );
  }
}
