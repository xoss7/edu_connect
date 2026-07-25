import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/student.dart';

Student studentFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Student(
    uid: doc.id,
    nom: data['nom'] as String,
    ecole: data['ecole'] as String,
    filiere: data['filiere'] as String,
    niveau: data['niveau'] as String,
    competences: List<String>.from(data['competences'] as List? ?? const []),
    reputationScore: data['reputationScore'] as int? ?? 0,
  );
}

// Always writes reputationScore: 0 — a profile can only ever be created at
// the initial score, regardless of what's set on the in-memory Student.
Map<String, dynamic> studentToCreateMap(Student student) {
  return {
    'nom': student.nom,
    'ecole': student.ecole,
    'filiere': student.filiere,
    'niveau': student.niveau,
    'competences': student.competences,
    'reputationScore': 0,
  };
}

// No reputationScore key at all — it's never part of a client-driven update.
Map<String, dynamic> studentToUpdateMap(Student student) {
  return {
    'nom': student.nom,
    'ecole': student.ecole,
    'filiere': student.filiere,
    'niveau': student.niveau,
    'competences': student.competences,
  };
}
