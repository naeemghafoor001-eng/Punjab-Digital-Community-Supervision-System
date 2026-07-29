import 'package:flutter_test/flutter_test.dart';
import 'package:supervisee_app/main.dart';
import 'package:supervisee_app/core/backend/auth_service.dart';

void main() {
  setUp(() async {
    await AuthService.instance.initialize();
  });

  testWidgets(
      'PDCSSSuperviseeApp initial direct home screen test (login bypassed)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSSuperviseeApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // Verify app opens directly to Home Dashboard
    expect(find.textContaining('Punjab Probation and Parole Service'),
        findsWidgets);
    expect(find.textContaining('Home / ہوم'), findsWidgets);

    // Verify Login and Logout buttons are not present in visible UI
    expect(find.text('Login / لاگ ان'), findsNothing);
    expect(find.text('Logout / لاگ آؤٹ'), findsNothing);
  });
}
