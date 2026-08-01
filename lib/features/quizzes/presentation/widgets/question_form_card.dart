import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class QuestionFormCard extends StatelessWidget {
  const QuestionFormCard({
    required this.index,
    required this.texteController,
    required this.optionControllers,
    required this.correctIndex,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onCorrectChanged,
    required this.onRemoveQuestion,
    super.key,
  });

  final int index;
  final TextEditingController texteController;
  final List<TextEditingController> optionControllers;
  final int? correctIndex;
  final VoidCallback onAddOption;
  final void Function(int optionIndex) onRemoveOption;
  final void Function(int? value) onCorrectChanged;
  final VoidCallback onRemoveQuestion;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${AppStrings.quizQuestionTexteLabel} ${index + 1}',
                    style: AppTextStyles.title,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemoveQuestion,
                  tooltip: AppStrings.quizRemoveQuestionButton,
                ),
              ],
            ),
            TextField(
              controller: texteController,
              decoration: const InputDecoration(
                labelText: AppStrings.quizQuestionTexteLabel,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              AppStrings.quizCorrectAnswerHint,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppDimensions.spaceXs),
            RadioGroup<int>(
              groupValue: correctIndex,
              onChanged: onCorrectChanged,
              child: Column(
                children: [
                  for (final entry in optionControllers.asMap().entries)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spaceSm,
                      ),
                      child: Row(
                        children: [
                          Radio<int>(value: entry.key),
                          Expanded(
                            child: TextField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                labelText:
                                    '${AppStrings.quizOptionLabel}'
                                    ' ${entry.key + 1}',
                              ),
                            ),
                          ),
                          if (optionControllers.length > 2)
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => onRemoveOption(entry.key),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: onAddOption,
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.quizAddOptionButton),
            ),
          ],
        ),
      ),
    );
  }
}
