class QuizAttempt {
  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.quizTitre,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.elapsedSeconds,
    required this.timestamp,
  });

  final String id;
  final String quizId;
  final String quizTitre;
  final String userId;
  final int score;
  final int totalQuestions;
  final int elapsedSeconds;
  final DateTime timestamp;
}
