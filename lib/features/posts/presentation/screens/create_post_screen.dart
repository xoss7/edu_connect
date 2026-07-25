import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/create_post_controller.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _texteController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _texteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _image = File(picked.path));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(createPostControllerProvider.notifier)
        .submit(texte: _texteController.text.trim(), image: _image);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(createPostControllerProvider, (
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

    final isSubmitting = ref.watch(createPostControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.postCreateTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _texteController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: AppStrings.postComposerHint,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? AppStrings.validationRequired
                      : null,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                if (_image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _image = null),
                    child: const Text(AppStrings.genericCancel),
                  ),
                ] else
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined),
                    label: const Text(AppStrings.postAddImage),
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
                      : const Text(AppStrings.postPublish),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
