enum MatchStatut {
  enAttente('en_attente'),
  accepte('accepte'),
  refuse('refuse');

  const MatchStatut(this.value);
  final String value;

  static MatchStatut fromString(String value) {
    return MatchStatut.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MatchStatut.enAttente,
    );
  }
}

class ProjectMatch {
  const ProjectMatch({
    required this.id,
    required this.projectId,
    required this.candidateId,
    required this.statut,
    required this.createdAt,
  });

  final String id;
  final String projectId;
  final String candidateId;
  final MatchStatut statut;
  final DateTime createdAt;
}
