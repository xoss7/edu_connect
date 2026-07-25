import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edu_connect/core/services/auth_service.dart';
import 'package:edu_connect/features/auth/presentation/screens/login_screen.dart';
import 'package:edu_connect/main.dart';

class _FakeAuthService implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> authStateChanges() => Stream.value(null);

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteCurrentUser() async {}
}

void main() {
  testWidgets('Unauthenticated user is redirected to the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider.overrideWithValue(_FakeAuthService())],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
