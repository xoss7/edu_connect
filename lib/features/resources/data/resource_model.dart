import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/resource.dart';

// Falls back to DateTime.now() for the brief window right after creation
// where FieldValue.serverTimestamp() hasn't resolved server-side yet and
// the field reads back as null (same pattern as post_model.dart).
Resource resourceFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Resource(
    id: doc.id,
    titre: data['titre'] as String,
    matiere: data['matiere'] as String,
    ecole: data['ecole'] as String,
    niveau: data['niveau'] as String,
    fileUrl: data['fileUrl'] as String,
    uploaderId: data['uploaderId'] as String,
    downloads: data['downloads'] as int? ?? 0,
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
