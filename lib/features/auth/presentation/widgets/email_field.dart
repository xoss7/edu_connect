import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class EmailField extends StatelessWidget {
  const EmailField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: AppStrings.authEmailLabel,
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppStrings.validationRequired;
        }
        if (!value.contains('@')) {
          return AppStrings.validationEmailInvalid;
        }
        return null;
      },
    );
  }
}
