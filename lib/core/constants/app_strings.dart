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
  static const String navResourcesLabel = 'Ressources';
  static const String navQuizzesLabel = 'Quiz';
  static const String navProfileLabel = 'Profil';

  // Common field labels (reused across features)
  static const String titreLabel = 'Titre';
  static const String matiereLabel = 'Matière';

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

  // Resources
  static const String resourcesTitle = 'Ressources';
  static const String resourcesEmptyMessage =
      'Aucune ressource pour l\'instant';
  static const String resourcesSearchHint = 'Rechercher un titre...';
  static const String resourcePickFileButton = 'Choisir un PDF';
  static const String resourceFileRequired = 'Sélectionne un fichier PDF';
  static const String resourceUploadTitle = 'Nouvelle ressource';
  static const String resourceUploadButton = 'Publier';
  static const String resourceDownloadButton = 'Télécharger';
  static const String resourceDownloadSuccess = 'Téléchargement terminé';
  static const String resourceDownloadsLabel = 'téléchargements';

  // Quizzes
  static const String quizzesTitle = 'Quiz';
  static const String quizzesEmptyMessage = 'Aucun quiz pour l\'instant';
  static const String quizzesSearchHint = 'Rechercher un titre ou matière...';
  static const String quizCreateTitle = 'Nouveau quiz';
  static const String quizQuestionsCountLabel = 'questions';
  static const String quizAddQuestionButton = 'Ajouter une question';
  static const String quizRemoveQuestionButton = 'Supprimer la question';
  static const String quizQuestionTexteLabel = 'Question';
  static const String quizOptionLabel = 'Option';
  static const String quizAddOptionButton = 'Ajouter une option';
  static const String quizCorrectAnswerHint = 'Réponse correcte';
  static const String quizPublishButton = 'Publier';
  static const String quizMinQuestionsError =
      'Ajoute au moins une question complète (question, au moins 2 options'
      ' et une réponse correcte sélectionnée)';
  static const String quizFinishButton = 'Terminer';
  static const String quizScoreResult = 'Score';
  static const String quizResultClose = 'Fermer';
  static const String quizAttemptsHistoryTitle = 'Historique des quiz';
  static const String quizAttemptsEmptyMessage =
      'Aucune tentative pour l\'instant';

  // Relative time
  static const String timeJustNow = 'À l\'instant';
  static const String timeMinutesSuffix = 'min';
  static const String timeHoursSuffix = 'h';
  static const String timeDaysSuffix = 'j';
}
