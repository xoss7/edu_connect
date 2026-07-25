import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/domain/niveau.dart';
import '../providers/register_controller.dart';
import 'email_field.dart';
import 'password_field.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ecoleController = TextEditingController();
  final _filiereController = TextEditingController();
  String? _niveau;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ecoleController.dispose();
    _filiereController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(registerControllerProvider.notifier)
        .submit(
          nom: _nomController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          ecole: _ecoleController.text.trim(),
          filiere: _filiereController.text.trim(),
          niveau: _niveau!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerControllerProvider).isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nomController,
            decoration: const InputDecoration(
              labelText: AppStrings.authNomLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          EmailField(controller: _emailController),
          const SizedBox(height: AppDimensions.spaceMd),
          PasswordField(controller: _passwordController),
          const SizedBox(height: AppDimensions.spaceMd),
          TextFormField(
            controller: _ecoleController,
            decoration: const InputDecoration(
              labelText: AppStrings.authEcoleLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          TextFormField(
            controller: _filiereController,
            decoration: const InputDecoration(
              labelText: AppStrings.authFiliereLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DropdownButtonFormField<String>(
            initialValue: _niveau,
            decoration: const InputDecoration(
              labelText: AppStrings.authNiveauLabel,
            ),
            items: Niveau.all
                .map(
                  (niveau) =>
                      DropdownMenuItem(value: niveau, child: Text(niveau)),
                )
                .toList(),
            onChanged: (value) => setState(() => _niveau = value),
            validator: (value) =>
                value == null ? AppStrings.validationRequired : null,
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          ElevatedButton(
            onPressed: isLoading ? null : _submit,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.authRegisterButton),
          ),
        ],
      ),
    );
  }
}
