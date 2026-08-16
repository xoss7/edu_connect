import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/question.dart';
import '../domain/quiz.dart';
import '../domain/quiz_attempt.dart';
import 'quiz_model.dart';

class QuizRepository {
  QuizRepository(this._supabase);

  final SupabaseClient _supabase;

  Stream<List<Quiz>> watchQuizzes() {
    return _supabase
        .from('quizzes')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(50)
        .map((data) => data.map(quizFromMap).toList());
  }

  Stream<Quiz> watchQuiz(String quizId) {
    return _supabase
        .from('quizzes')
        .stream(primaryKey: ['id'])
        .eq('id', quizId)
        .map((data) => quizFromMap(data.first));
  }

  Future<void> createQuiz({
    required String createurId,
    required String titre,
    required String matiere,
    required List<Question> questions,
  }) async {
    await _supabase.from('quizzes').insert({
      'createur_id': createurId,
      'titre': titre,
      'matiere': matiere,
      'questions': questions.map(questionToMap).toList(),
    });
  }

  Stream<List<QuizAttempt>> watchAttemptsForUser(String uid) {
    return _supabase
        .from('quiz_attempts')
        .stream(primaryKey: ['id'])
        .eq('user_id', uid)
        .order('created_at', ascending: false)
        .map((data) => data.map(quizAttemptFromMap).toList());
  }

  Future<void> submitAttempt({
    required String quizId,
    required String quizTitre,
    required String userId,
    required int score,
    required int totalQuestions,
    required int elapsedSeconds,
  }) async {
    await _supabase.from('quiz_attempts').insert({
      'quiz_id': quizId,
      'quiz_titre': quizTitre,
      'user_id': userId,
      'score': score,
      'total_questions': totalQuestions,
      'elapsed_seconds': elapsedSeconds,
    });
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(Supabase.instance.client);
});
