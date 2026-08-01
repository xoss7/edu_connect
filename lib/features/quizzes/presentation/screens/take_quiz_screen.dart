import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/quiz.dart';
import '../providers/quiz_providers.dart';
import '../providers/submit_quiz_attempt_controller.dart';

String _formatElapsed(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class TakeQuizScreen extends ConsumerStatefulWidget {
  const TakeQuizScreen({required this.quizId, super.key});

  final String quizId;

  @override
  ConsumerState<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends ConsumerState<TakeQuizScreen> {
  late final Timer _timer;
  int _elapsedSeconds = 0;
  List<int?> _selectedAnswers = [];
  bool _initialized = false;
  int _lastScore = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _elapsedSeconds++),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Only sizes the answers list once the quiz loads — later stream
  // emissions shouldn't wipe answers already picked mid-attempt.
  void _initializeAnswers(Quiz quiz) {
    if (_initialized) return;
    _selectedAnswers = List<int?>.filled(quiz.questions.length, null);
    _initialized = true;
  }

  void _submit(Quiz quiz) {
    _timer.cancel();
    var score = 0;
    for (var i = 0; i < quiz.questions.length; i++) {
      if (_selectedAnswers[i] == quiz.questions[i].reponseCorrecteIndex) {
        score++;
      }
    }
    _lastScore = score;
    ref
        .read(submitQuizAttemptControllerProvider.notifier)
        .submit(quiz: quiz, score: score, elapsedSeconds: _elapsedSeconds);
  }

  void _showResultDialog(Quiz quiz) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.quizScoreResult),
        content: Text('$_lastScore / ${quiz.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.quizResultClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizProvider(widget.quizId));

    ref.listen<AsyncValue<void>>(submitQuizAttemptControllerProvider, (
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
        final quiz = quizAsync.value;
        if (quiz != null) _showResultDialog(quiz);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(quizAsync.value?.titre ?? AppStrings.quizzesTitle),
      ),
      body: quizAsync.when(
        data: (quiz) {
          _initializeAnswers(quiz);
          return _TakeQuizBody(
            quiz: quiz,
            selectedAnswers: _selectedAnswers,
            elapsedLabel: _formatElapsed(_elapsedSeconds),
            onAnswerChanged: (questionIndex, value) =>
                setState(() => _selectedAnswers[questionIndex] = value),
            onSubmit: () => _submit(quiz),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
    );
  }
}

class _TakeQuizBody extends ConsumerWidget {
  const _TakeQuizBody({
    required this.quiz,
    required this.selectedAnswers,
    required this.elapsedLabel,
    required this.onAnswerChanged,
    required this.onSubmit,
  });

  final Quiz quiz;
  final List<int?> selectedAnswers;
  final String elapsedLabel;
  final void Function(int questionIndex, int? value) onAnswerChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref
        .watch(submitQuizAttemptControllerProvider)
        .isLoading;
    final allAnswered = !selectedAnswers.contains(null);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined),
                const SizedBox(width: AppDimensions.spaceXs),
                Text(elapsedLabel, style: AppTextStyles.title),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            for (final entry in quiz.questions.asMap().entries)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.key + 1}. ${entry.value.texte}',
                          style: AppTextStyles.title,
                        ),
                        RadioGroup<int>(
                          groupValue: selectedAnswers[entry.key],
                          onChanged: (value) =>
                              onAnswerChanged(entry.key, value),
                          child: Column(
                            children: [
                              for (final option
                                  in entry.value.options.asMap().entries)
                                RadioListTile<int>(
                                  value: option.key,
                                  title: Text(option.value),
                                  contentPadding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: (allAnswered && !isSubmitting) ? onSubmit : null,
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(AppStrings.quizFinishButton),
            ),
          ],
        ),
      ),
    );
  }
}
