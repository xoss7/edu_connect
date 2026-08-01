import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/question.dart';
import '../domain/quiz.dart';
import '../domain/quiz_attempt.dart';

Question _questionFromMap(Map<String, dynamic> map) {
  return Question(
    texte: map['texte'] as String,
    options: List<String>.from(map['options'] as List),
    reponseCorrecteIndex: map['reponseCorrecteIndex'] as int,
  );
}

Map<String, dynamic> questionToMap(Question question) {
  return {
    'texte': question.texte,
    'options': question.options,
    'reponseCorrecteIndex': question.reponseCorrecteIndex,
  };
}

// Falls back to DateTime.now() for the brief window right after creation
// where FieldValue.serverTimestamp() hasn't resolved server-side yet and
// the field reads back as null (same pattern as post_model.dart).
Quiz quizFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Quiz(
    id: doc.id,
    titre: data['titre'] as String,
    matiere: data['matiere'] as String,
    questions: (data['questions'] as List)
        .map((question) => _questionFromMap(question as Map<String, dynamic>))
        .toList(),
    createurId: data['createurId'] as String,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

QuizAttempt quizAttemptFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return QuizAttempt(
    id: doc.id,
    quizId: data['quizId'] as String,
    quizTitre: data['quizTitre'] as String,
    userId: data['userId'] as String,
    score: data['score'] as int,
    totalQuestions: data['totalQuestions'] as int,
    elapsedSeconds: data['elapsedSeconds'] as int,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
