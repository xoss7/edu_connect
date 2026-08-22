import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/project_repository.dart';
import '../../domain/project_match.dart';

class ProjectActionsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createProject({
    required String titre,
    required String description,
    required List<String> competences,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;
      try {
        debugPrint('Creating project in Supabase...');
        await ref.read(projectRepositoryProvider).createProject(
          auteurId: uid,
          titre: titre,
          description: description,
          competences: competences,
        );
        debugPrint('Project created successfully.');
      } catch (e, st) {
        debugPrint('Error creating project: $e');
        debugPrint(st.toString());
        rethrow;
      }
    });
  }

  Future<void> applyToProject(String projectId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;
      await ref.read(projectRepositoryProvider).applyToProject(
        projectId: projectId,
        candidateId: uid,
      );
    });
  }

  Future<void> updateMatchStatus(String matchId, MatchStatut status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(projectRepositoryProvider).updateMatchStatus(matchId, status);
    });
  }
}

final projectActionsControllerProvider =
    AsyncNotifierProvider<ProjectActionsController, void>(ProjectActionsController.new);
