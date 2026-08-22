# EduConnect Sénégal

Application Flutter d'entraide académique pour les étudiants des écoles
supérieures du Sénégal (ESP, UCAD, ISM, EPT, ENSA, etc.).

Les étudiants de disciplines complémentaires manquent souvent d'un espace
commun pour partager des ressources, se rencontrer et collaborer sur des
projets. EduConnect répond à trois besoins :

- un accès centralisé aux ressources pédagogiques (cours, annales),
  à la place des groupes WhatsApp désorganisés,
- un espace commun entre écoles et filières,
- une mise en relation structurée pour trouver des collaborateurs de
  projet selon les compétences recherchées.

## Fonctionnalités

- **Profils étudiants** : nom, école, filière, niveau, compétences,
  score de réputation calculé en fonction des contributions.
- **Fil d'actualité** : posts texte avec image optionnelle, filtrables
  par école, filière et niveau, avec likes et commentaires.
- **Partage de ressources** : upload de PDF avec métadonnées (titre,
  matière, école, niveau), recherche et filtres, prévisualisation dans
  l'app avant téléchargement, compteur de téléchargements.
- **QCM collaboratifs** : création de quiz à choix multiples, mode
  passage chronométré, historique des tentatives visible sur le profil.
- **Matching de collaborateurs** : publication d'annonces de projet
  avec compétences recherchées, candidatures, acceptation ou refus par
  l'auteur.
- **Messagerie** : conversations 1 à 1, ouvertes automatiquement quand
  une candidature de projet est acceptée, ou démarrées manuellement
  depuis la liste des candidats.

Le détail complet du cahier des charges se trouve dans `SPEC.md`.

## Stack technique

- Flutter, avec Riverpod pour la gestion d'état et go_router pour la
  navigation (shell à onglets pour Accueil, Messages et Profil, routes
  plein écran pour les autres fonctionnalités).
- Supabase comme backend complet : Auth, base Postgres avec écoute en
  temps réel via `supabase_flutter`, et Storage pour les fichiers.
- Architecture feature first : chaque fonctionnalité vit dans
  `lib/features/<nom>/` avec ses propres couches `domain`, `data` et
  `presentation`, et le code partagé se trouve dans `lib/core/`.