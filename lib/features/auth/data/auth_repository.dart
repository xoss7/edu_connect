import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<User> signIn({required String email, required String password}) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<User> register({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.register(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> deleteCurrentUser() => _authService.deleteCurrentUser();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authServiceProvider));
});
