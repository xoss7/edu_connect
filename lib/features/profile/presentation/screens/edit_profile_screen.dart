import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/niveau.dart';
import '../../domain/student.dart';
import '../providers/profile_providers.dart';
import '../widgets/competences_input.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({required this.uid, super.key});

  final String uid;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _ecoleController = TextEditingController();
  final _filiereController = TextEditingController();
  String? _niveau;
  List<String> _competences = [];
  bool _initialized = false;

  @override
  void dispose() {
    _nomController.dispose();
    _ecoleController.dispose();
    _filiereController.dispose();
    super.dispose();
  }

  // Only prefills once — later stream emissions while the user is editing
  // shouldn't stomp their in-progress changes.
  void _initializeFrom(Student student) {
    if (_initialized) return;
    _nomController.text = student.nom;
    _ecoleController.text = student.ecole;
    _filiereController.text = student.filiere;
    _niveau = student.niveau;
    _competences = List.of(student.competences);
    _initialized = true;
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  void _submit(Student current) {
    if (!_formKey.currentState!.validate()) return;
    final updated = current.copyWith(
      nom: _nomController.text.trim(),
      ecole: _ecoleController.text.trim(),
      filiere: _filiereController.text.trim(),
      niveau: _niveau,
      competences: _competences,
    );
    ref.read(editProfileControllerProvider.notifier).submit(updated);
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentProvider(widget.uid));

    ref.listen<AsyncValue<void>>(editProfileControllerProvider, (
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

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.profileEditTitle)),
      body: studentAsync.when(
        data: (student) {
          _initializeFrom(student);
          return _EditProfileForm(
            formKey: _formKey,
            nomController: _nomController,
            ecoleController: _ecoleController,
            filiereController: _filiereController,
            niveau: _niveau,
            competences: _competences,
            onNiveauChanged: (value) => setState(() => _niveau = value),
            onCompetencesChanged: (value) => _competences = value,
            requiredValidator: _requiredValidator,
            onSubmit: () => _submit(student),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
    );
  }
}

class _EditProfileForm extends ConsumerWidget {
  const _EditProfileForm({
    required this.formKey,
    required this.nomController,
    required this.ecoleController,
    required this.filiereController,
    required this.niveau,
    required this.competences,
    required this.onNiveauChanged,
    required this.onCompetencesChanged,
    required this.requiredValidator,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nomController;
  final TextEditingController ecoleController;
  final TextEditingController filiereController;
  final String? niveau;
  final List<String> competences;
  final ValueChanged<String?> onNiveauChanged;
  final ValueChanged<List<String>> onCompetencesChanged;
  final FormFieldValidator<String> requiredValidator;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaving = ref.watch(editProfileControllerProvider).isLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: AppStrings.authNomLabel,
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              TextFormField(
                controller: ecoleController,
                decoration: const InputDecoration(
                  labelText: AppStrings.authEcoleLabel,
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              TextFormField(
                controller: filiereController,
                decoration: const InputDecoration(
                  labelText: AppStrings.authFiliereLabel,
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              DropdownButtonFormField<String>(
                initialValue: niveau,
                decoration: const InputDecoration(
                  labelText: AppStrings.authNiveauLabel,
                ),
                items: Niveau.all
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: onNiveauChanged,
                validator: (value) =>
                    value == null ? AppStrings.validationRequired : null,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              CompetencesInput(
                initialCompetences: competences,
                onChanged: onCompetencesChanged,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              ElevatedButton(
                onPressed: isSaving ? null : onSubmit,
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.genericSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
