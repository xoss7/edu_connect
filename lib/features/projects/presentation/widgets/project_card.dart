import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../domain/project.dart';
import 'skill_chip.dart';

class ProjectCard extends ConsumerWidget {
  const ProjectCard({required this.project, required this.onTap, super.key});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(studentProvider(project.auteurId));

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialsAvatar(
                    name: authorAsync.value?.nom ?? '',
                    radius: 18,
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Text(
                      authorAsync.value?.nom ?? 'Étudiant',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: project.isOuvert
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      project.statut.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: project.isOuvert ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                project.titre,
                style: AppTextStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.competencesRecherchees
                    .map((skill) => SkillChip(label: skill, isSelected: true))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
