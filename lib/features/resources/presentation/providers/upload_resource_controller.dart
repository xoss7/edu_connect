import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/resource_repository.dart';

class UploadResourceController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required String titre,
    required String matiere,
    required String ecole,
    required String niveau,
    required File file,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final uid = ref.read(authServiceProvider).currentUser!.id;

      try {
        debugPrint('Uploading file to storage...');
        final fileUrl = await ref.read(storageServiceProvider).uploadFile(
          path: 'resources/$uid/${DateTime.now().millisecondsSinceEpoch}.pdf',
          file: file,
        );
        debugPrint('File uploaded: $fileUrl');

        debugPrint('Creating resource record in database...');
        await ref.read(resourceRepositoryProvider).createResource(
          uploaderId: uid,
          titre: titre,
          matiere: matiere,
          ecole: ecole,
          niveau: niveau,
          fileUrl: fileUrl,
        );
        debugPrint('Resource record created.');
      } catch (e, st) {
        debugPrint('Error uploading resource: $e');
        debugPrint(st.toString());
        rethrow;
      }
    });
  }
}

final uploadResourceControllerProvider =
    AsyncNotifierProvider<UploadResourceController, void>(
      UploadResourceController.new,
    );
