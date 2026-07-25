class Student {
  const Student({
    required this.uid,
    required this.nom,
    required this.ecole,
    required this.filiere,
    required this.niveau,
    this.competences = const [],
    this.reputationScore = 0,
  });

  final String uid;
  final String nom;
  final String ecole;
  final String filiere;
  final String niveau;
  final List<String> competences;
  final int reputationScore;

  // No reputationScore parameter here on purpose: it's server-computed and
  // read-only, so there's no code path in the app that should ever set it.
  Student copyWith({
    String? nom,
    String? ecole,
    String? filiere,
    String? niveau,
    List<String>? competences,
  }) {
    return Student(
      uid: uid,
      nom: nom ?? this.nom,
      ecole: ecole ?? this.ecole,
      filiere: filiere ?? this.filiere,
      niveau: niveau ?? this.niveau,
      competences: competences ?? this.competences,
      reputationScore: reputationScore,
    );
  }
}
