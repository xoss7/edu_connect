import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/question.dart';
import '../domain/quiz.dart';
import '../domain/quiz_attempt.dart';
import 'quiz_model.dart';

class QuizRepository {
  QuizRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _quizzes =>
      _firestore.collection(FirestorePaths.quizzes);

  CollectionReference<Map<String, dynamic>> get _quizAttempts =>
      _firestore.collection(FirestorePaths.quizAttempts);

  Stream<List<Quiz>> watchQuizzes() {
    return _quizzes
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(quizFromDoc).toList());
  }

  Stream<Quiz> watchQuiz(String quizId) {
    return _quizzes.doc(quizId).snapshots().map(quizFromDoc);
  }

  Future<void> createQuiz({
    required String createurId,
    required String titre,
    required String matiere,
    required List<Question> questions,
  }) {
    return _quizzes.add({
      'createurId': createurId,
      'titre': titre,
      'matiere': matiere,
      'questions': questions.map(questionToMap).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Plain equality filter + orderBy on a different field — Firestore
  // handles this with automatic single-field indexes, no composite index
  // needed (unlike a range filter combined with a different orderBy).
  Stream<List<QuizAttempt>> watchAttemptsForUser(String uid) {
    return _quizAttempts
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(quizAttemptFromDoc).toList());
  }

  Future<void> submitAttempt({
    required String quizId,
    required String quizTitre,
    required String userId,
    required int score,
    required int totalQuestions,
    required int elapsedSeconds,
  }) {
    return _quizAttempts.add({
      'quizId': quizId,
      'quizTitre': quizTitre,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'elapsedSeconds': elapsedSeconds,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(FirebaseFirestore.instance);
});
