import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/firestore_paths.dart';
import '../domain/student.dart';
import 'student_model.dart';

class ProfileRepository {
  ProfileRepository(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) {
    return _firestore.collection(FirestorePaths.users).doc(uid);
  }

  Future<void> createProfile(Student student) {
    return _doc(student.uid).set(studentToCreateMap(student));
  }

  Future<Student> getProfile(String uid) async {
    final snapshot = await _doc(uid).get();
    if (!snapshot.exists) {
      throw StateError('Profile $uid does not exist');
    }
    return studentFromDoc(snapshot);
  }

  // Filters out the brief window right after signup where the Firebase Auth
  // account exists but the Firestore profile doc hasn't been written yet.
  Stream<Student> watchProfile(String uid) {
    return _doc(
      uid,
    ).snapshots().where((snapshot) => snapshot.exists).map(studentFromDoc);
  }

  Future<void> updateProfile(Student student) {
    return _doc(student.uid).update(studentToUpdateMap(student));
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(FirebaseFirestore.instance);
});
