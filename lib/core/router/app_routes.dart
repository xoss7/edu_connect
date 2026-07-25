class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String feed = '/feed';

  // Relative to [profile] — full path is '/profile/edit'.
  static const String editProfile = 'edit';

  // Relative to [feed] — full paths are '/feed/create' and '/feed/:postId'.
  static const String createPost = 'create';
  static const String postDetail = ':postId';
}
