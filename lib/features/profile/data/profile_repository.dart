import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/student.dart';
import 'student_model.dart';

class ProfileRepository {
  ProfileRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<void> createProfile(Student student) async {
    await _supabase.from('profiles').update(studentToMap(student)).eq('id', student.uid);
  }

  Future<Student> getProfile(String uid) async {
    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .single();
    return studentFromMap(data);
  }

  Stream<Student> watchProfile(String uid) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((data) {
          if (data.isEmpty) {
            // Handle case where profile isn't in the DB yet
            throw StateError('Profile not found');
          }
          return studentFromMap(data.first);
        });
  }

  Future<void> updateProfile(Student student) async {
    await _supabase
        .from('profiles')
        .update(studentToMap(student))
        .eq('id', student.uid);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});
