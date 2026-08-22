import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/project.dart';
import '../domain/project_match.dart';
import 'project_model.dart';

class ProjectRepository {
  ProjectRepository(this._supabase);

  final SupabaseClient _supabase;

  Stream<List<Project>> watchProjects() {
    return _supabase
        .from('projects')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map(projectFromMap).toList());
  }

  Future<void> createProject({
    required String auteurId,
    required String titre,
    required String description,
    required List<String> competences,
  }) async {
    await _supabase.from('projects').insert({
      'auteur_id': auteurId,
      'titre': titre,
      'description': description,
      'competences_recherchees': competences,
      'statut': 'ouvert',
    });
  }

  Future<void> applyToProject({
    required String projectId,
    required String candidateId,
  }) async {
    await _supabase.from('matches').insert({
      'project_id': projectId,
      'candidate_id': candidateId,
      'statut': 'en_attente',
    });
  }

  Stream<List<ProjectMatch>> watchMatchesForProject(String projectId) {
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('project_id', projectId)
        .order('created_at', ascending: false)
        .map((data) => data.map(projectMatchFromMap).toList());
  }

  Stream<List<ProjectMatch>> watchApplicationsForUser(String userId) {
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('candidate_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map(projectMatchFromMap).toList());
  }

  Future<void> updateMatchStatus(String matchId, MatchStatut status) async {
    await _supabase
        .from('matches')
        .update({'statut': status.value})
        .eq('id', matchId);
  }
}

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(Supabase.instance.client);
});
