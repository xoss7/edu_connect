import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../profile/domain/niveau.dart';
import '../providers/resource_providers.dart';

class ResourceFiltersSheet extends ConsumerStatefulWidget {
  const ResourceFiltersSheet({super.key});

  @override
  ConsumerState<ResourceFiltersSheet> createState() =>
      _ResourceFiltersSheetState();
}

class _ResourceFiltersSheetState extends ConsumerState<ResourceFiltersSheet> {
  late final TextEditingController _matiereController;
  late final TextEditingController _ecoleController;
  String? _niveau;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(resourceFiltersProvider);
    _matiereController = TextEditingController(text: filters.matiere);
    _ecoleController = TextEditingController(text: filters.ecole);
    _niveau = filters.niveau;
  }

  @override
  void dispose() {
    _matiereController.dispose();
    _ecoleController.dispose();
    super.dispose();
  }

  void _apply() {
    final notifier = ref.read(resourceFiltersProvider.notifier);
    final matiere = _matiereController.text.trim();
    final ecole = _ecoleController.text.trim();
    notifier.setMatiere(matiere.isEmpty ? null : matiere);
    notifier.setEcole(ecole.isEmpty ? null : ecole);
    notifier.setNiveau(_niveau);
    Navigator.of(context).pop();
  }

  void _clear() {
    ref.read(resourceFiltersProvider.notifier).clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.feedFilterTitle, style: AppTextStyles.title),
          const SizedBox(height: AppDimensions.spaceMd),
          TextField(
            controller: _matiereController,
            decoration: const InputDecoration(
              labelText: AppStrings.matiereLabel,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          TextField(
            controller: _ecoleController,
            decoration: const InputDecoration(
              labelText: AppStrings.authEcoleLabel,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          DropdownButtonFormField<String?>(
            initialValue: _niveau,
            decoration: const InputDecoration(
              labelText: AppStrings.authNiveauLabel,
            ),
            items: [
              const DropdownMenuItem(child: Text(AppStrings.feedAllNiveaux)),
              ...Niveau.all.map(
                (niveau) =>
                    DropdownMenuItem(value: niveau, child: Text(niveau)),
              ),
            ],
            onChanged: (value) => setState(() => _niveau = value),
          ),
          const SizedBox(height: AppDimensions.spaceLg),
          ElevatedButton(
            onPressed: _apply,
            child: const Text(AppStrings.genericSave),
          ),
          TextButton(
            onPressed: _clear,
            child: const Text(AppStrings.feedClearFilters),
          ),
        ],
      ),
    );
  }
}
