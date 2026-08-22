import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((state) {
      // Only notify if the session status changes (ignoring mere token refreshes if possible,
      // but simpler to check if user ID changed)
      final newUserId = state.session?.user.id;
      if (newUserId != _currentUserId) {
        _currentUserId = newUserId;
        notifyListeners();
      }
    });
  }

  late final StreamSubscription<AuthState> _subscription;
  String? _currentUserId;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterRefreshProvider = Provider<GoRouterRefreshStream>((ref) {
  final notifier = GoRouterRefreshStream(
    ref.watch(authServiceProvider).authStateChanges(),
  );
  ref.onDispose(notifier.dispose);
  return notifier;
});
