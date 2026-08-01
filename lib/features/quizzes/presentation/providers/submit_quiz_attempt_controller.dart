import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/quiz_repository.dart';
import '../../domain/quiz.dart';

class SubmitQuizAttemptController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required Quiz quiz,
    required int score,
    required int elapsedSeconds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.uid;
      await ref
          .read(quizRepositoryProvider)
          .submitAttempt(
            quizId: quiz.id,
            quizTitre: quiz.titre,
            userId: uid,
            score: score,
            totalQuestions: quiz.questions.length,
            elapsedSeconds: elapsedSeconds,
          );
    });
  }
}

final submitQuizAttemptControllerProvider =
    AsyncNotifierProvider<SubmitQuizAttemptController, void>(
      SubmitQuizAttemptController.new,
    );
