class AppRoutes {
  const AppRoutes._();

  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String feed = '/feed';
  static const String resources = '/resources';
  static const String quizzes = '/quizzes';
  static const String messages = '/messages';
  static const String projects = '/projects';

  // Relative to [projects]
  static const String createProject = 'create';
  static const String projectDetail = ':projectId';

  // Relative to [profile] — full path is '/profile/edit'.
  static const String editProfile = 'edit';

  // Relative to [feed] — full paths are '/feed/create' and '/feed/:postId'.
  static const String createPost = 'create';
  static const String postDetail = ':postId';

  // Relative to [resources] — full paths are '/resources/upload' and
  // '/resources/:resourceId'.
  static const String uploadResource = 'upload';
  static const String resourceDetail = ':resourceId';

  // Relative to [quizzes] — full paths are '/quizzes/create' and
  // '/quizzes/:quizId'.
  static const String createQuiz = 'create';
  static const String takeQuiz = ':quizId';
}
