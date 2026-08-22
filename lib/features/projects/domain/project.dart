class Project {
  const Project({
    required this.id,
    required this.auteurId,
    required this.titre,
    required this.description,
    required this.competencesRecherchees,
    required this.statut,
    required this.createdAt,
  });

  final String id;
  final String auteurId;
  final String titre;
  final String description;
  final List<String> competencesRecherchees;
  final String statut; // 'ouvert', 'ferme'
  final DateTime createdAt;

  bool get isOuvert => statut == 'ouvert';

  bool matchesSkills(List<String> userSkills) {
    if (competencesRecherchees.isEmpty) return true;
    final userSkillsLower = userSkills.map((s) => s.toLowerCase()).toSet();
    return competencesRecherchees.any((skill) => 
      userSkillsLower.contains(skill.toLowerCase())
    );
  }
}
