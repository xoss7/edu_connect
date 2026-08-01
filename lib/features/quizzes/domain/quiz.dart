import 'question.dart';

class Quiz {
  const Quiz({
    required this.id,
    required this.titre,
    required this.matiere,
    required this.questions,
    required this.createurId,
    required this.timestamp,
  });

  final String id;
  final String titre;
  final String matiere;
  final List<Question> questions;
  final String createurId;
  final DateTime timestamp;
}
