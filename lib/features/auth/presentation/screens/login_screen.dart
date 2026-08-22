import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/login_controller.dart';
import '../widgets/auth_illustration.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginControllerProvider.notifier)
        .submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginControllerProvider, (previous, next) {
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

    final isLoading = ref.watch(loginControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spaceLg),
                const AuthIllustration(assetPath: AppAssets.loginIllustration),
                const SizedBox(height: AppDimensions.spaceLg),
                const Text(
                  AppStrings.authLoginHeadline,
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                const Text(
                  AppStrings.authLoginSubtitle,
                  style: AppTextStyles.subtitle,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                EmailField(controller: _emailController),
                const SizedBox(height: AppDimensions.spaceMd),
                PasswordField(controller: _passwordController),
                const SizedBox(height: AppDimensions.spaceLg),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.authLoginButton),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.authNoAccountPrompt,
                      style: AppTextStyles.body,
                    ),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.register),
                      child: const Text(AppStrings.authRegisterButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
