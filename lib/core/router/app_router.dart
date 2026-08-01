import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/login_controller.dart';
import '../../features/auth/presentation/providers/register_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/posts/presentation/screens/create_post_screen.dart';
import '../../features/posts/presentation/screens/feed_screen.dart';
import '../../features/posts/presentation/screens/post_detail_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/resources/presentation/screens/resource_detail_screen.dart';
import '../../features/resources/presentation/screens/resources_screen.dart';
import '../../features/resources/presentation/screens/upload_resource_screen.dart';
import '../services/auth_service.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: ref.watch(goRouterRefreshProvider),
    redirect: (context, state) {
      final loggedIn = ref.read(authServiceProvider).currentUser != null;
      final loggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (loggingIn) {
        // Don't navigate away from /login or /register while a submit is in
        // flight: Firebase may report a signed-in user mid-registration,
        // before the Firestore profile doc exists or before a failed
        // profile write has triggered the auth-account rollback.
        final busy =
            ref.read(loginControllerProvider).isLoading ||
            ref.read(registerControllerProvider).isLoading;
        if (busy) return null;
      }

      if (!loggedIn) return loggingIn ? null : AppRoutes.login;
      if (loggingIn || state.matchedLocation == '/') return AppRoutes.feed;
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
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
                    builder: (context, state) => PostDetailScreen(
                      postId: state.pathParameters['postId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
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
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => ProfileScreen(
                  uid: ref.read(authServiceProvider).currentUser!.uid,
                ),
                routes: [
                  GoRoute(
                    path: AppRoutes.editProfile,
                    builder: (context, state) => EditProfileScreen(
                      uid: ref.read(authServiceProvider).currentUser!.uid,
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
