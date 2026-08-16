import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/data/profile_repository.dart';
import '../../../profile/domain/student.dart';
import '../../data/auth_repository.dart';

class RegisterController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String nom,
    required String email,
    required String password,
    required String ecole,
    required String filiere,
    required String niveau,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final profileRepository = ref.read(profileRepositoryProvider);

      final user = await authRepository.register(
        email: email,
        password: password,
        nom: nom,
      );

      final student = Student(
        uid: user.id,
        nom: nom,
        ecole: ecole,
        filiere: filiere,
        niveau: niveau,
      );

      try {
        await profileRepository.createProfile(student);
      } catch (_) {
        // Avoid leaving an orphaned Auth account with no profile behind.
        await authRepository.deleteCurrentUser();
        rethrow;
      }
    });
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, void>(RegisterController.new);
