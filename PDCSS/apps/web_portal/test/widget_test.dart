import 'package:flutter_test/flutter_test.dart';
import 'package:web_portal/main.dart';

void main() {
  testWidgets('PDCSSWebPortalApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSWebPortalApp());
    expect(find.textContaining('Raahnuma Management Portal'), findsOneWidget);
  });
}
