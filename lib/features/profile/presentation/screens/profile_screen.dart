import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/data/auth_repository.dart';
import '../providers/profile_providers.dart';
import '../widgets/competences_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/quiz_attempts_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({required this.uid, super.key});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: studentAsync.when(
        data: (student) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: Column(
            children: [
              ProfileHeader(student: student),
              const SizedBox(height: AppDimensions.spaceLg),
              ProfileInfoCard(student: student),
              const SizedBox(height: AppDimensions.spaceLg),
              CompetencesCard(competences: student.competences),
              const SizedBox(height: AppDimensions.spaceLg),
              QuizAttemptsCard(uid: uid),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text(AppStrings.genericError)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.go('${AppRoutes.profile}/${AppRoutes.editProfile}'),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
