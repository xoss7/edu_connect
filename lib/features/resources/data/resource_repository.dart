import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/resource.dart';
import 'resource_model.dart';

class ResourceRepository {
  ResourceRepository(this._supabase);

  final SupabaseClient _supabase;

  Stream<List<Resource>> watchResources() {
    return _supabase
        .from('resources')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(50)
        .map((data) => data.map(resourceFromMap).toList());
  }

  Stream<Resource> watchResource(String resourceId) {
    return _supabase
        .from('resources')
        .stream(primaryKey: ['id'])
        .eq('id', resourceId)
        .map((data) => resourceFromMap(data.first));
  }

  Future<void> createResource({
    required String uploaderId,
    required String titre,
    required String matiere,
    required String ecole,
    required String niveau,
    required String fileUrl,
  }) async {
    await _supabase.from('resources').insert({
      'uploader_id': uploaderId,
      'titre': titre,
      'matiere': matiere,
      'ecole': ecole,
      'niveau': niveau,
      'file_url': fileUrl,
      'downloads': 0,
    });
  }

  Future<void> incrementDownloads(String resourceId) async {
    // Note: increment in SQL is better done via RPC or simple update
    // For simplicity, we get current and increment
    final resource = await _supabase.from('resources').select('downloads').eq('id', resourceId).single();
    final downloads = (resource['downloads'] as int) + 1;
    await _supabase.from('resources').update({'downloads': downloads}).eq('id', resourceId);
  }
}

final resourceRepositoryProvider = Provider<ResourceRepository>((ref) {
  return ResourceRepository(Supabase.instance.client);
});
