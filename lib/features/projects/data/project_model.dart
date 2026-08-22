import '../domain/project.dart';
import '../domain/project_match.dart';

Project projectFromMap(Map<String, dynamic> data) {
  return Project(
    id: data['id'] as String,
    auteurId: data['auteur_id'] as String,
    titre: data['titre'] as String,
    description: data['description'] as String,
    competencesRecherchees: List<String>.from(
      data['competences_recherchees'] as List? ?? [],
    ),
    statut: data['statut'] as String? ?? 'ouvert',
    createdAt: DateTime.parse(data['created_at'] as String),
  );
}

ProjectMatch projectMatchFromMap(Map<String, dynamic> data) {
  return ProjectMatch(
    id: data['id'] as String,
    projectId: data['project_id'] as String,
    candidateId: data['candidate_id'] as String,
    statut: MatchStatut.fromString(data['statut'] as String),
    createdAt: DateTime.parse(data['created_at'] as String),
  );
}
