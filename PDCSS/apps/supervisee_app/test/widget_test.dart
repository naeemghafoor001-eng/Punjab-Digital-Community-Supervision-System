import 'package:flutter_test/flutter_test.dart';
import 'package:supervisee_app/main.dart';

void main() {
  testWidgets('PDCSSSuperviseeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSSuperviseeApp());
    expect(find.textContaining('Raahnuma Dashboard'), findsOneWidget);
  });
}
