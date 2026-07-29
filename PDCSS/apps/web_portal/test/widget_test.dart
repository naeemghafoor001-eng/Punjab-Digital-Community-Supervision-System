import 'package:flutter_test/flutter_test.dart';
import 'package:web_portal/main.dart';

void main() {
  testWidgets('PDCSSWebPortalApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSWebPortalApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.textContaining('Management Portal'), findsWidgets);
  });
}
