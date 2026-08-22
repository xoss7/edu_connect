import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../widgets/feature_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    final studentAsync = ref.watch(studentProvider(user?.id ?? ''));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HomeHeader(
                name: studentAsync.value?.nom ?? '',
                score: studentAsync.value?.reputationScore ?? 0,
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              Text(
                "Qu'est-ce qu'on fait aujourd'hui ?",
                style: AppTextStyles.title.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              // Feature Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppDimensions.spaceMd,
                mainAxisSpacing: AppDimensions.spaceMd,
                children: [
                  FeatureTile(
                    title: "Fil d'actualité",
                    assetPath: AppAssets.feedTile,
                    onTap: () => context.push(AppRoutes.feed),
                  ),
                  FeatureTile(
                    title: "Ressources",
                    assetPath: AppAssets.resourcesTile,
                    onTap: () => context.push(AppRoutes.resources),
                  ),
                  FeatureTile(
                    title: "Quiz",
                    assetPath: AppAssets.quizzesTile,
                    onTap: () => context.push(AppRoutes.quizzes),
                  ),
                  FeatureTile(
                    title: "Mon Profil",
                    assetPath: AppAssets.profileTile,
                    onTap: () => context.go(AppRoutes.profile),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              // Upcoming Feature / Special Highlight
              FeatureTile(
                title: "Matching de Projets",
                assetPath: AppAssets.projectsTile,
                isLarge: true,
                onTap: () => context.push(AppRoutes.projects),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.name, required this.score});

  final String name;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bonjour,",
                style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
              ),
              Text(
                name.isNotEmpty ? name : "Étudiant",
                style: AppTextStyles.headline.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 20),
              const SizedBox(width: 4),
              Text(
                "$score pts",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
