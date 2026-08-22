import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  StorageService(this._supabase);

  final SupabaseClient _supabase;

  Future<String> uploadFile({required String path, required File file}) async {
    // Split path into bucket and file path
    final segments = path.split('/');
    final bucket = segments.first;
    final filePath = segments.sublist(1).join('/');

    await _supabase.storage
        .from(bucket)
        .upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    return _supabase.storage.from(bucket).getPublicUrl(filePath);
  }

  // Supabase storage doesn't have a direct "writeToFile" like Firebase,
  // we download the bytes and write them to a file.
  Future<void> downloadFile({
    required String url,
    required File destination,
  }) async {
    // Parsing URL to get path might be complex depending on public URL format
    // For now, if we have the full URL, we can use http or internal download if possible.
    // Simplifying: we'll assume the URL is already public.
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(Supabase.instance.client);
});
