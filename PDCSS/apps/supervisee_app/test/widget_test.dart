import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supervisee_app/main.dart';
import 'package:supervisee_app/core/backend/auth_service.dart';

void main() {
  setUp(() async {
    await AuthService.instance.signOut();
  });

  testWidgets('PDCSSSuperviseeApp initial login screen test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSSuperviseeApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Punjab Probation and Parole Service'),
        findsWidgets);
    expect(find.textContaining('Raahnuma Supervisee App'), findsWidgets);
    expect(find.textContaining('Access Helper'), findsWidgets);
    expect(find.textContaining('Login / لاگ ان'), findsOneWidget);
  });

  testWidgets('PDCSSSuperviseeApp login flow test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSSuperviseeApp());
    await tester.pumpAndSettle();

    // Tap Login button with default filled demo credentials
    final loginBtn = find.widgetWithText(ElevatedButton, 'Login / لاگ ان');
    expect(loginBtn, findsOneWidget);
    await tester.tap(loginBtn);
    await tester.pumpAndSettle(const Duration(milliseconds: 800));

    // After login, dashboard should be visible
    expect(find.textContaining('Raahnuma Dashboard'), findsWidgets);
  });
}
