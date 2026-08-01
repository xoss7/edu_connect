import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/question.dart';
import '../providers/create_quiz_controller.dart';
import '../widgets/question_form_card.dart';

class _QuestionDraft {
  final texteController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  int? correctIndex;

  void dispose() {
    texteController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
  }
}

class CreateQuizScreen extends ConsumerStatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _matiereController = TextEditingController();
  final List<_QuestionDraft> _questions = [_QuestionDraft()];

  @override
  void dispose() {
    _titreController.dispose();
    _matiereController.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired;
    }
    return null;
  }

  void _addQuestion() => setState(() => _questions.add(_QuestionDraft()));

  void _removeQuestion(int index) {
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _addOption(int questionIndex) {
    setState(
      () => _questions[questionIndex].optionControllers.add(
        TextEditingController(),
      ),
    );
  }

  void _removeOption(int questionIndex, int optionIndex) {
    setState(() {
      _questions[questionIndex].optionControllers
          .removeAt(optionIndex)
          .dispose();
    });
  }

  void _setCorrect(int questionIndex, int? value) {
    setState(() => _questions[questionIndex].correctIndex = value);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final questions = <Question>[];
    for (final draft in _questions) {
      final texte = draft.texteController.text.trim();
      final options = draft.optionControllers
          .map((controller) => controller.text.trim())
          .where((option) => option.isNotEmpty)
          .toList();
      final correctIndex = draft.correctIndex;
      if (texte.isEmpty || options.length < 2 || correctIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.quizMinQuestionsError)),
        );
        return;
      }
      questions.add(
        Question(
          texte: texte,
          options: options,
          reponseCorrecteIndex: correctIndex,
        ),
      );
    }

    ref
        .read(createQuizControllerProvider.notifier)
        .submit(
          titre: _titreController.text.trim(),
          matiere: _matiereController.text.trim(),
          questions: questions,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(createQuizControllerProvider, (
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
      appBar: AppBar(title: const Text(AppStrings.quizCreateTitle)),
      body: _CreateQuizForm(
        formKey: _formKey,
        titreController: _titreController,
        matiereController: _matiereController,
        questions: _questions,
        requiredValidator: _requiredValidator,
        onAddQuestion: _addQuestion,
        onRemoveQuestion: _removeQuestion,
        onAddOption: _addOption,
        onRemoveOption: _removeOption,
        onCorrectChanged: _setCorrect,
        onSubmit: _submit,
      ),
    );
  }
}

class _CreateQuizForm extends ConsumerWidget {
  const _CreateQuizForm({
    required this.formKey,
    required this.titreController,
    required this.matiereController,
    required this.questions,
    required this.requiredValidator,
    required this.onAddQuestion,
    required this.onRemoveQuestion,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onCorrectChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titreController;
  final TextEditingController matiereController;
  final List<_QuestionDraft> questions;
  final FormFieldValidator<String> requiredValidator;
  final VoidCallback onAddQuestion;
  final void Function(int index) onRemoveQuestion;
  final void Function(int questionIndex) onAddOption;
  final void Function(int questionIndex, int optionIndex) onRemoveOption;
  final void Function(int questionIndex, int? value) onCorrectChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref.watch(createQuizControllerProvider).isLoading;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titreController,
                decoration: const InputDecoration(
                  labelText: AppStrings.titreLabel,
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              TextFormField(
                controller: matiereController,
                decoration: const InputDecoration(
                  labelText: AppStrings.matiereLabel,
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              for (final entry in questions.asMap().entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                  child: QuestionFormCard(
                    index: entry.key,
                    texteController: entry.value.texteController,
                    optionControllers: entry.value.optionControllers,
                    correctIndex: entry.value.correctIndex,
                    onAddOption: () => onAddOption(entry.key),
                    onRemoveOption: (optionIndex) =>
                        onRemoveOption(entry.key, optionIndex),
                    onCorrectChanged: (value) =>
                        onCorrectChanged(entry.key, value),
                    onRemoveQuestion: () => onRemoveQuestion(entry.key),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: onAddQuestion,
                icon: const Icon(Icons.add),
                label: const Text(AppStrings.quizAddQuestionButton),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(AppStrings.quizPublishButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
