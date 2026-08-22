import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/login_controller.dart';
import '../../features/auth/presentation/providers/register_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/posts/presentation/screens/create_post_screen.dart';
import '../../features/posts/presentation/screens/feed_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/quizzes/presentation/screens/create_quiz_screen.dart';
import '../../features/quizzes/presentation/screens/quizzes_screen.dart';
import '../../features/quizzes/presentation/screens/take_quiz_screen.dart';
import '../../features/projects/presentation/screens/create_project_screen.dart';
import '../../features/projects/presentation/screens/project_detail_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/resources/presentation/screens/resource_detail_screen.dart';
import '../../features/resources/presentation/screens/resources_screen.dart';
import '../../features/resources/presentation/screens/upload_resource_screen.dart';
import '../services/auth_service.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: ref.watch(goRouterRefreshProvider),
    redirect: (context, state) {
      final loggedIn = ref.read(authServiceProvider).currentUser != null;
      final loggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (loggingIn) {
        final busy =
            ref.read(loginControllerProvider).isLoading ||
            ref.read(registerControllerProvider).isLoading;
        if (busy) return null;
      }

      if (!loggedIn) return loggingIn ? null : AppRoutes.login;
      if (loggingIn) return AppRoutes.home;
      if (state.matchedLocation == '/') return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.feed,
        builder: (context, state) => const FeedScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createPost,
            builder: (context, state) => const CreatePostScreen(),
          ),
          GoRoute(
            path: AppRoutes.postDetail,
            builder: (context, state) =>
                PostDetailScreen(postId: state.pathParameters['postId']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.resources,
        builder: (context, state) => const ResourcesScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.uploadResource,
            builder: (context, state) => const UploadResourceScreen(),
          ),
          GoRoute(
            path: AppRoutes.resourceDetail,
            builder: (context, state) => ResourceDetailScreen(
              resourceId: state.pathParameters['resourceId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.quizzes,
        builder: (context, state) => const QuizzesScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createQuiz,
            builder: (context, state) => const CreateQuizScreen(),
          ),
          GoRoute(
            path: AppRoutes.takeQuiz,
            builder: (context, state) =>
                TakeQuizScreen(quizId: state.pathParameters['quizId']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => const ProjectsScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.createProject,
            builder: (context, state) => const CreateProjectScreen(),
          ),
          GoRoute(
            path: AppRoutes.projectDetail,
            builder: (context, state) => ProjectDetailScreen(
              projectId: state.pathParameters['projectId']!,
            ),
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.messages,
                builder: (context, state) =>
                    const Center(child: Text("Messages (Bientôt)")),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => ProfileScreen(
                  uid: ref.read(authServiceProvider).currentUser!.id,
                ),
                routes: [
                  GoRoute(
                    path: AppRoutes.editProfile,
                    builder: (context, state) => EditProfileScreen(
                      uid: ref.read(authServiceProvider).currentUser!.id,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
