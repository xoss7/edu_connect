import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/storage_service.dart';
import '../../data/resource_repository.dart';
import '../../domain/resource.dart';

class DownloadResourceController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> download(Resource resource) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final directory = await getApplicationDocumentsDirectory();
      // Uses the Firestore doc id rather than the free-text titre, which
      // may contain characters that aren't safe in a file name.
      final destination = File('${directory.path}/${resource.id}.pdf');

      await ref
          .read(storageServiceProvider)
          .downloadFile(url: resource.fileUrl, destination: destination);

      await ref
          .read(resourceRepositoryProvider)
          .incrementDownloads(resource.id);
    });
  }
}

final downloadResourceControllerProvider =
    AsyncNotifierProvider<DownloadResourceController, void>(
      DownloadResourceController.new,
    );
