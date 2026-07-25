import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_repository.dart';
import '../../domain/student.dart';

final studentProvider = StreamProvider.family<Student, String>((ref, uid) {
  return ref.watch(profileRepositoryProvider).watchProfile(uid);
});

class EditProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit(Student updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(profileRepositoryProvider).updateProfile(updated),
    );
  }
}

final editProfileControllerProvider =
    AsyncNotifierProvider<EditProfileController, void>(
      EditProfileController.new,
    );
