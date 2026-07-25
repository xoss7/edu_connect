import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../profile/data/profile_repository.dart';
import '../../data/post_repository.dart';

class CreatePostController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({required String texte, File? image}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.uid;
      final author = await ref.read(profileRepositoryProvider).getProfile(uid);

      String? imageUrl;
      if (image != null) {
        imageUrl = await ref
            .read(storageServiceProvider)
            .uploadFile(
              path: 'posts/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg',
              file: image,
            );
      }

      await ref
          .read(postRepositoryProvider)
          .createPost(
            auteurId: uid,
            texte: texte,
            imageUrl: imageUrl,
            ecole: author.ecole,
            filiere: author.filiere,
            niveau: author.niveau,
          );
    });
  }
}

final createPostControllerProvider =
    AsyncNotifierProvider<CreatePostController, void>(CreatePostController.new);
