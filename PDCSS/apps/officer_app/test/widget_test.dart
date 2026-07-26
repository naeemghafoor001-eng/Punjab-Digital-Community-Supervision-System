import 'package:flutter_test/flutter_test.dart';
import 'package:officer_app/main.dart';

void main() {
  testWidgets('PDCSSOfficerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSOfficerApp());
    expect(find.textContaining('PDCSS Officer Dashboard'), findsOneWidget);
  });
}
