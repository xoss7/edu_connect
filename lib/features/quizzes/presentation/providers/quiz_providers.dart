import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/quiz_repository.dart';
import '../../domain/quiz.dart';
import '../../domain/quiz_attempt.dart';

class QuizSearchNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setQuery(String? value) => state = value;
}

final quizSearchProvider = NotifierProvider<QuizSearchNotifier, String?>(
  QuizSearchNotifier.new,
);

// Titre/matière match case-insensitively via `contains` — same free-text
// reasoning as feed/resources filtering.
final quizzesProvider = StreamProvider<List<Quiz>>((ref) {
  final query = ref.watch(quizSearchProvider);
  return ref
      .watch(quizRepositoryProvider)
      .watchQuizzes()
      .map(
        (quizzes) => quizzes.where((quiz) {
          if (query == null) return true;
          final lowerQuery = query.toLowerCase();
          return quiz.titre.toLowerCase().contains(lowerQuery) ||
              quiz.matiere.toLowerCase().contains(lowerQuery);
        }).toList(),
      );
});

final quizProvider = StreamProvider.family<Quiz, String>((ref, quizId) {
  return ref.watch(quizRepositoryProvider).watchQuiz(quizId);
});

final quizAttemptsProvider = StreamProvider.family<List<QuizAttempt>, String>((
  ref,
  uid,
) {
  return ref.watch(quizRepositoryProvider).watchAttemptsForUser(uid);
});
