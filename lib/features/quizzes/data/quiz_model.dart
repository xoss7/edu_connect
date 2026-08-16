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

Quiz quizFromMap(Map<String, dynamic> data) {
  return Quiz(
    id: data['id'] as String,
    titre: data['titre'] as String,
    matiere: data['matiere'] as String,
    questions: (data['questions'] as List)
        .map((question) => _questionFromMap(question as Map<String, dynamic>))
        .toList(),
    createurId: data['createur_id'] as String,
    timestamp: DateTime.parse(data['created_at'] as String),
  );
}

QuizAttempt quizAttemptFromMap(Map<String, dynamic> data) {
  return QuizAttempt(
    id: data['id'] as String,
    quizId: data['quiz_id'] as String,
    quizTitre: data['quiz_titre'] as String,
    userId: data['user_id'] as String,
    score: data['score'] as int,
    totalQuestions: data['total_questions'] as int,
    elapsedSeconds: data['elapsed_seconds'] as int,
    timestamp: DateTime.parse(data['created_at'] as String),
  );
}
