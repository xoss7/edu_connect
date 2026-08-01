class Question {
  const Question({
    required this.texte,
    required this.options,
    required this.reponseCorrecteIndex,
  });

  final String texte;
  final List<String> options;
  final int reponseCorrecteIndex;
}
