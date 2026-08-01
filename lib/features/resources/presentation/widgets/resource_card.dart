import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/resource.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({required this.resource, super.key});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => context.push('${AppRoutes.resources}/${resource.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(resource.titre, style: AppTextStyles.title),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(resource.ecole, style: AppTextStyles.caption),
              const SizedBox(height: AppDimensions.spaceSm),
              Wrap(
                spacing: AppDimensions.spaceSm,
                runSpacing: AppDimensions.spaceSm,
                children: [
                  _Tag(label: resource.matiere),
                  _Tag(label: resource.niveau),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Row(
                children: [
                  const Icon(
                    Icons.download_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.spaceXs),
                  Text('${resource.downloads}', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.primary),
      ),
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
