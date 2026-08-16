import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
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
              Navigator.of(context).pop(); // Ferme le dialog
              context.go(AppRoutes.quizzes); // Retourne à la liste des quiz
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
            onAnswerChanged: (questionIndex, value) {
              HapticFeedback.selectionClick();
              setState(() => _selectedAnswers[questionIndex] = value);
            },
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
    final isSubmitting =
        ref.watch(submitQuizAttemptControllerProvider).isLoading;
    final answeredCount = selectedAnswers.where((a) => a != null).length;
    final progress = answeredCount / quiz.questions.length;
    final allAnswered = answeredCount == quiz.questions.length;

    return SafeArea(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceVariant,
            color: AppColors.primary,
            minHeight: 6,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceLg,
                        vertical: AppDimensions.spaceMd,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusPill),
                        boxShadow: AppColors.softShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppDimensions.spaceSm),
                          Text(
                            elapsedLabel,
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  for (final entry in quiz.questions.asMap().entries)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppDimensions.spaceLg),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusLg),
                          boxShadow: AppColors.softShadow,
                          border: Border.all(
                            color: AppColors.textPrimary.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppDimensions.spaceLg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimensions.spaceMd),
                                  Expanded(
                                    child: Text(
                                      entry.value.texte,
                                      style: AppTextStyles.title.copyWith(
                                        fontSize: 18,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimensions.spaceLg),
                              RadioGroup<int>(
                                groupValue: selectedAnswers[entry.key],
                                onChanged: (value) =>
                                    onAnswerChanged(entry.key, value),
                                child: Column(
                                  children: [
                                    for (final option
                                        in entry.value.options.asMap().entries)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppDimensions.spaceSm,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              AppDimensions.radiusMd,
                                            ),
                                            color: selectedAnswers[entry.key] ==
                                                    option.key
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.05,
                                                  )
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: selectedAnswers[entry.key] ==
                                                      option.key
                                                  ? AppColors.primary
                                                  : AppColors.textPrimary
                                                      .withValues(alpha: 0.1),
                                            ),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: RadioListTile<int>(
                                              value: option.key,
                                              title: Text(
                                                option.value,
                                                style: AppTextStyles.body.copyWith(
                                                  color:
                                                      selectedAnswers[entry.key] ==
                                                              option.key
                                                          ? AppColors.primary
                                                          : AppColors.textPrimary,
                                                  fontWeight:
                                                      selectedAnswers[entry.key] ==
                                                              option.key
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                ),
                                              ),
                                              activeColor: AppColors.primary,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                        AppDimensions.spaceMd,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.spaceLg),
                  ElevatedButton(
                    onPressed: (allAnswered && !isSubmitting) ? onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primary,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          AppStrings.quizFinishButton,
                          style: AppTextStyles.title.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
