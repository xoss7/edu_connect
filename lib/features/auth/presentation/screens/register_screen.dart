import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/register_controller.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(registerControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
        return;
      }
      if (previous?.isLoading == true && !next.isLoading) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spaceLg),
              const AuthIllustration(assetPath: AppAssets.registerIllustration),
              const SizedBox(height: AppDimensions.spaceLg),
              const Text(
                AppStrings.authRegisterHeadline,
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              const Text(
                AppStrings.authRegisterSubtitle,
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              const RegisterForm(),
              const SizedBox(height: AppDimensions.spaceMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.authHasAccountPrompt,
                    style: AppTextStyles.body,
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text(AppStrings.authLoginButton),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
