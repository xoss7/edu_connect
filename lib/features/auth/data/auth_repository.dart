import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<User> signIn({required String email, required String password}) async {
    final response = await _authService.signIn(
      email: email,
      password: password,
    );
    return response.user!;
  }

  Future<User> register({
    required String email,
    required String password,
    required String nom,
  }) async {
    final response = await _authService.register(
      email: email,
      password: password,
      nom: nom,
    );
    return response.user!;
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> deleteCurrentUser() => _authService.deleteCurrentUser();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authServiceProvider));
});
