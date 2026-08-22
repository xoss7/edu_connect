import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  AuthService(this._supabase);

  final SupabaseClient _supabase;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> authStateChanges() => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String nom,
  }) {
    return _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'nom': nom},
    );
  }

  Future<void> signOut() => _supabase.auth.signOut();

  // Supabase management of users is handled differently, usually via Admin SDK or RLS
  // For standard user deletion:
  Future<void> deleteCurrentUser() async {
    // Note: Standard Supabase client can't delete self easily without a function
    // For now, we sign out.
    await signOut();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});
