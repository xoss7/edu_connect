import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  StorageService(this._firebaseStorage);

  final FirebaseStorage _firebaseStorage;

  Future<String> uploadFile({required String path, required File file}) async {
    final ref = _firebaseStorage.ref(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> downloadFile({
    required String url,
    required File destination,
  }) async {
    await _firebaseStorage.refFromURL(url).writeToFile(destination);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(FirebaseStorage.instance);
});
