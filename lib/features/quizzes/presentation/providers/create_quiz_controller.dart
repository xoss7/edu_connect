import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../data/quiz_repository.dart';
import '../../domain/question.dart';

class CreateQuizController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String titre,
    required String matiere,
    required List<Question> questions,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;
      try {
        await ref.read(quizRepositoryProvider).createQuiz(
          createurId: uid,
          titre: titre,
          matiere: matiere,
          questions: questions,
        );
      } catch (e, st) {
        debugPrint('Error creating quiz: $e');
        debugPrint(st.toString());
        rethrow;
      }
    });
  }
}

final createQuizControllerProvider =
    AsyncNotifierProvider<CreateQuizController, void>(CreateQuizController.new);
