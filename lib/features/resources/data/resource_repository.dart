import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/resource.dart';
import 'resource_model.dart';

class ResourceRepository {
  ResourceRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _resources =>
      _firestore.collection(FirestorePaths.resources);

  // No server-side filtering here — matière/école/niveau filters are
  // applied client-side (see resource_providers.dart), same reasoning as
  // post_repository.dart's watchFeed: matière/école are free text, so an
  // exact Firestore `where` would silently miss any case/spelling
  // difference. Keeping the query to a single orderBy also avoids needing
  // a composite index.
  Stream<List<Resource>> watchResources() {
    return _resources
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(resourceFromDoc).toList());
  }

  Future<void> createResource({
    required String uploaderId,
    required String titre,
    required String matiere,
    required String ecole,
    required String niveau,
    required String fileUrl,
  }) {
    return _resources.add({
      'uploaderId': uploaderId,
      'titre': titre,
      'matiere': matiere,
      'ecole': ecole,
      'niveau': niveau,
      'fileUrl': fileUrl,
      'downloads': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> incrementDownloads(String resourceId) {
    return _resources.doc(resourceId).update({
      'downloads': FieldValue.increment(1),
    });
  }
}

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  return ResourceRepository(FirebaseFirestore.instance);
});
