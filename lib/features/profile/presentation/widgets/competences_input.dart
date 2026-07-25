import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class CompetencesInput extends ConsumerStatefulWidget {
  const CompetencesInput({
    required this.initialCompetences,
    required this.onChanged,
    super.key,
  });

  final List<String> initialCompetences;
  final ValueChanged<List<String>> onChanged;

  @override
  ConsumerState<CompetencesInput> createState() => _CompetencesInputState();
}

class _CompetencesInputState extends ConsumerState<CompetencesInput> {
  late List<String> _competences = List.of(widget.initialCompetences);
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty || _competences.contains(value)) return;
    setState(() => _competences = [..._competences, value]);
    widget.onChanged(_competences);
    _controller.clear();
  }

  void _remove(String competence) {
    setState(
      () => _competences = _competences.where((c) => c != competence).toList(),
    );
    widget.onChanged(_competences);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.profileCompetencesLabel, style: AppTextStyles.title),
        const SizedBox(height: AppDimensions.spaceSm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: AppStrings.profileAddCompetenceHint,
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: _add),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        Wrap(
          spacing: AppDimensions.spaceSm,
          runSpacing: AppDimensions.spaceSm,
          children: _competences
              .map(
                (competence) => Chip(
                  label: Text(competence),
                  onDeleted: () => _remove(competence),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
