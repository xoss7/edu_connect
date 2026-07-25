import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/data/auth_repository.dart';
import '../providers/profile_providers.dart';
import '../widgets/student_info_card.dart';

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
        data: (student) => Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          child: StudentInfoCard(student: student),
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
