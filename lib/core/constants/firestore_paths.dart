class FirestorePaths {
  const FirestorePaths._();

  static const String users = 'users';
  static const String posts = 'posts';
  static const String resources = 'resources';
  static const String quizzes = 'quizzes';
  static const String quizAttempts = 'quiz_attempts';
  static const String projects = 'projects';
  static const String matches = 'matches';
  static const String conversations = 'conversations';
  static const String messages = 'messages';

  // Subcollection of a `posts/{postId}` document.
  static const String postComments = 'comments';
}
