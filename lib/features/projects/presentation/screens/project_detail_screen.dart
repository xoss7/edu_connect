import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/project_actions_controller.dart';
import '../providers/project_providers.dart';
import '../widgets/skill_chip.dart';
import '../../domain/project_match.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProjectsAsync = ref.watch(allProjectsProvider);
    final currentUserId = ref.watch(authServiceProvider).currentUser?.id;

    return allProjectsAsync.when(
      data: (projects) {
        final project = projects.firstWhere((p) => p.id == projectId);
        final isAuthor = project.auteurId == currentUserId;
        final authorAsync = ref.watch(studentProvider(project.auteurId));

        return Scaffold(
          appBar: AppBar(title: const Text("Détails du Projet")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    InitialsAvatar(
                      name: authorAsync.value?.nom ?? '',
                      radius: 24,
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorAsync.value?.nom ?? 'Étudiant',
                          style: AppTextStyles.title.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          authorAsync.value?.ecole ?? '',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                Text(project.titre, style: AppTextStyles.headline),
                const SizedBox(height: AppDimensions.spaceMd),
                Text(project.description, style: AppTextStyles.body),
                const SizedBox(height: AppDimensions.spaceLg),
                Text("Compétences recherchées", style: AppTextStyles.title),
                const SizedBox(height: AppDimensions.spaceSm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.competencesRecherchees
                      .map((s) => SkillChip(label: s, isSelected: true))
                      .toList(),
                ),
                const SizedBox(height: AppDimensions.spaceLg),
                if (isAuthor) ...[
                  const Divider(),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text("Candidatures", style: AppTextStyles.title),
                  _ApplicantList(projectId: projectId),
                ] else
                  _ApplyButton(projectId: projectId),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          const Scaffold(body: Center(child: Text(AppStrings.genericError))),
    );
  }
}

class _ApplyButton extends ConsumerWidget {
  const _ApplyButton({required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(userApplicationsProvider);
    final isLoading = ref.watch(projectActionsControllerProvider).isLoading;

    return applicationsAsync.when(
      data: (apps) {
        final alreadyApplied = apps.any((a) => a.projectId == projectId);
        if (alreadyApplied) {
          return const ElevatedButton(
            onPressed: null,
            child: Text("Déjà postulé"),
          );
        }
        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () => ref
                    .read(projectActionsControllerProvider.notifier)
                    .applyToProject(projectId),
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text("Postuler pour rejoindre l'équipe"),
        );
      },
      loading: () => const ElevatedButton(
        onPressed: null,
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _ApplicantList extends ConsumerWidget {
  const _ApplicantList({required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(projectMatchesProvider(projectId));

    return matchesAsync.when(
      data: (matches) => matches.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Aucune candidature pour le moment.",
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                final candidateAsync = ref.watch(
                  studentProvider(match.candidateId),
                );
                return ListTile(
                  leading: InitialsAvatar(
                    name: candidateAsync.value?.nom ?? '',
                    radius: 16,
                  ),
                  title: Text(candidateAsync.value?.nom ?? 'Candidat'),
                  subtitle: Text("Statut: ${match.statut.value}"),
                  trailing: match.statut.value == 'en_attente'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () => ref
                                  .read(
                                    projectActionsControllerProvider.notifier,
                                  )
                                  .updateMatchStatus(
                                    match.id,
                                    MatchStatut.accepte,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => ref
                                  .read(
                                    projectActionsControllerProvider.notifier,
                                  )
                                  .updateMatchStatus(
                                    match.id,
                                    MatchStatut.refuse,
                                  ),
                            ),
                          ],
                        )
                      : null,
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text("Erreur: $e"),
    );
  }
}
