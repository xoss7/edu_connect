import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/login_controller.dart';
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
        context.go(AppRoutes.profile);
      }
    });

    final isLoading = ref.watch(loginControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.authLoginTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                TextButton(
                  onPressed: () => context.go(AppRoutes.register),
                  child: const Text(AppStrings.authNoAccountPrompt),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
