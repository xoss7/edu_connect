import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../profile/presentation/widgets/competences_input.dart';
import '../providers/project_actions_controller.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _competences = [];

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_competences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ajoute au moins une compétence recherchée.")),
      );
      return;
    }

    ref.read(projectActionsControllerProvider.notifier).createProject(
      titre: _titreController.text.trim(),
      description: _descriptionController.text.trim(),
      competences: _competences,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(projectActionsControllerProvider, (prev, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.genericError)),
        );
      } else if (prev?.isLoading == true && !next.isLoading) {
        Navigator.of(context).pop();
      }
    });

    final isLoading = ref.watch(projectActionsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Publier un Projet")),
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
                  decoration: const InputDecoration(labelText: "Titre du projet"),
                  validator: (v) => (v == null || v.isEmpty) ? AppStrings.validationRequired : null,
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description / Objectifs",
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  validator: (v) => (v == null || v.isEmpty) ? AppStrings.validationRequired : null,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                Text(
                  "Compétences recherchées",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                CompetencesInput(
                  initialCompetences: _competences,
                  onChanged: (val) => _competences = val,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Publier l'annonce"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
