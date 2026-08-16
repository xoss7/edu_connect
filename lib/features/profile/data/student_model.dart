import '../domain/student.dart';

Student studentFromMap(Map<String, dynamic> data) {
  return Student(
    uid: data['id'] as String,
    nom: data['nom'] as String,
    ecole: data['ecole'] as String,
    filiere: data['filiere'] as String,
    niveau: data['niveau'] as String,
    competences: List<String>.from(data['competences'] as List? ?? const []),
    reputationScore: data['reputation_score'] as int? ?? 0,
  );
}

Map<String, dynamic> studentToMap(Student student) {
  return {
    'id': student.uid,
    'nom': student.nom,
    'ecole': student.ecole,
    'filiere': student.filiere,
    'niveau': student.niveau,
    'competences': student.competences,
  };
}
