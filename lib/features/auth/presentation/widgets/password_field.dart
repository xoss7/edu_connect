import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';

class PasswordField extends ConsumerStatefulWidget {
  const PasswordField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  ConsumerState<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: AppStrings.authPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.validationRequired;
        }
        if (value.length < 6) {
          return AppStrings.validationPasswordTooShort;
        }
        return null;
      },
    );
  }
}
