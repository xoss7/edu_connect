import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edu_connect/core/constants/app_strings.dart';
import 'package:edu_connect/main.dart';

void main() {
  testWidgets('App boots and shows the placeholder home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
  });
}
