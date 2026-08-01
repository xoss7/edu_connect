import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/domain/niveau.dart';
import '../providers/upload_resource_controller.dart';

class UploadResourceScreen extends ConsumerStatefulWidget {
  const UploadResourceScreen({super.key});

  @override
  ConsumerState<UploadResourceScreen> createState() =>
      _UploadResourceScreenState();
}

class _UploadResourceScreenState extends ConsumerState<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _matiereController = TextEditingController();
  final _ecoleController = TextEditingController();
  String? _niveau;
  PlatformFile? _pickedFile;

  @override
  void dispose() {
    _titreController.dispose();
    _matiereController.dispose();
    _ecoleController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    setState(() => _pickedFile = result.files.single);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final pickedFile = _pickedFile;
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.resourceFileRequired)),
      );
      return;
    }
    ref
        .read(uploadResourceControllerProvider.notifier)
        .submit(
          titre: _titreController.text.trim(),
          matiere: _matiereController.text.trim(),
          ecole: _ecoleController.text.trim(),
          niveau: _niveau!,
          file: File(pickedFile.path!),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(uploadResourceControllerProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.genericError)));
        return;
      }
      if (previous?.isLoading == true && !next.isLoading) {
        Navigator.of(context).pop();
      }
    });

    final isSubmitting = ref.watch(uploadResourceControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.resourceUploadTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titreController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.titreLabel,
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                TextFormField(
                  controller: _matiereController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.matiereLabel,
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                TextFormField(
                  controller: _ecoleController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.authEcoleLabel,
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
                        (niveau) => DropdownMenuItem(
                          value: niveau,
                          child: Text(niveau),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _niveau = value),
                  validator: (value) =>
                      value == null ? AppStrings.validationRequired : null,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                if (_pickedFile != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.picture_as_pdf_outlined),
                    title: Text(
                      _pickedFile!.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _pickedFile = null),
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text(AppStrings.resourcePickFileButton),
                  ),
                const SizedBox(height: AppDimensions.spaceLg),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.resourceUploadButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
