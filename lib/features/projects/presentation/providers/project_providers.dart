import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../data/project_repository.dart';
import '../../domain/project.dart';
import '../../domain/project_match.dart';

final allProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).watchProjects();
});

final projectsForYouProvider = Provider<AsyncValue<List<Project>>>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return const AsyncValue.data([]);

  final studentAsync = ref.watch(studentProvider(user.id));
  final allProjectsAsync = ref.watch(allProjectsProvider);

  return studentAsync.when(
    data: (student) => allProjectsAsync.whenData(
      (projects) =>
          projects.where((p) => p.matchesSkills(student.competences)).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

final projectMatchesProvider =
    StreamProvider.family<List<ProjectMatch>, String>((ref, projectId) {
      return ref
          .watch(projectRepositoryProvider)
          .watchMatchesForProject(projectId);
    });

final userApplicationsProvider = StreamProvider<List<ProjectMatch>>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return Stream.value([]);
  return ref.watch(projectRepositoryProvider).watchApplicationsForUser(user.id);
});
