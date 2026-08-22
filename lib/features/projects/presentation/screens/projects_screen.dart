import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/project_providers.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Collaboration Projets"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Tous"),
              Tab(text: "Pour toi"),
            ],
            indicatorColor: AppColors.onPrimary,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            _ProjectList(isForYou: false),
            _ProjectList(isForYou: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('${AppRoutes.projects}/${AppRoutes.createProject}'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _ProjectList extends ConsumerWidget {
  const _ProjectList({required this.isForYou});

  final bool isForYou;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(isForYou ? projectsForYouProvider : allProjectsProvider);

    return projectsAsync.when(
      data: (projects) => projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: AppDimensions.spaceMd),
                  Text(
                    isForYou ? "Aucun projet ne match avec tes compétences." : "Aucun projet publié pour le moment.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spaceLg),
              itemCount: projects.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
                child: ProjectCard(
                  project: projects[index],
                  onTap: () => context.push('${AppRoutes.projects}/${projects[index].id}'),
                ),
              ),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text(AppStrings.genericError)),
    );
  }
}
