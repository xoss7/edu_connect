import '../domain/resource.dart';

Resource resourceFromMap(Map<String, dynamic> data) {
  return Resource(
    id: data['id'] as String,
    titre: data['titre'] as String,
    matiere: data['matiere'] as String,
    ecole: data['ecole'] as String,
    niveau: data['niveau'] as String,
    fileUrl: data['file_url'] as String,
    uploaderId: data['uploader_id'] as String,
    downloads: data['downloads'] as int? ?? 0,
    timestamp: DateTime.parse(data['created_at'] as String),
  );
}
