class AppStrings {
  const AppStrings._();

  static const String appName = 'EduConnect Sénégal';

  static const String genericLoading = 'Chargement...';
  static const String genericError = 'Une erreur est survenue';
  static const String genericCancel = 'Annuler';
  static const String genericSave = 'Enregistrer';
  static const String genericRetry = 'Réessayer';

  // Navigation
  static const String navFeedLabel = 'Fil';
  static const String navProfileLabel = 'Profil';

  // Auth
  static const String authEmailLabel = 'Email';
  static const String authPasswordLabel = 'Mot de passe';
  static const String authNomLabel = 'Nom';
  static const String authEcoleLabel = 'École';
  static const String authFiliereLabel = 'Filière';
  static const String authNiveauLabel = 'Niveau';
  static const String authLoginTitle = 'Connexion';
  static const String authRegisterTitle = 'Inscription';
  static const String authLoginHeadline = 'Content de te revoir !';
  static const String authLoginSubtitle = 'Connecte-toi pour continuer';
  static const String authRegisterHeadline = 'Créons ton compte';
  static const String authRegisterSubtitle = 'Rejoins la communauté EduConnect';
  static const String authLoginButton = 'Se connecter';
  static const String authRegisterButton = 'Créer un compte';
  static const String authNoAccountPrompt = 'Pas encore de compte ?';
  static const String authHasAccountPrompt = 'Déjà un compte ?';
  static const String authLogoutButton = 'Se déconnecter';

  // Validation
  static const String validationRequired = 'Champ requis';
  static const String validationEmailInvalid = 'Email invalide';
  static const String validationPasswordTooShort =
      'Le mot de passe doit contenir au moins 6 caractères';

  // Profile
  static const String profileTitle = 'Profil';
  static const String profileEditTitle = 'Modifier le profil';
  static const String profileReputationLabel = 'Réputation';
  static const String profileCompetencesLabel = 'Compétences';
  static const String profileAddCompetenceHint = 'Ajouter une compétence';
  static const String profileFieldSeparator = ' · ';
  static const String profileNoCompetences =
      'Aucune compétence renseignée pour l\'instant';

  // Feed
  static const String feedTitle = 'Fil d\'actualité';
  static const String feedEmptyMessage = 'Aucun post pour l\'instant';
  static const String feedFilterTitle = 'Filtres';
  static const String feedClearFilters = 'Effacer les filtres';
  static const String feedAllNiveaux = 'Tous les niveaux';
  static const String postComposerHint = 'Quoi de neuf ?';
  static const String postDetailTitle = 'Post';
  static const String postCreateTitle = 'Nouveau post';
  static const String postAddImage = 'Ajouter une image';
  static const String postPublish = 'Publier';
  static const String commentInputHint = 'Ajouter un commentaire...';

  // Relative time
  static const String timeJustNow = 'À l\'instant';
  static const String timeMinutesSuffix = 'min';
  static const String timeHoursSuffix = 'h';
  static const String timeDaysSuffix = 'j';
}
