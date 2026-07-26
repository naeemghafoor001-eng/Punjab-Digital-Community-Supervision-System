import 'package:flutter_test/flutter_test.dart';
import 'package:supervisee_app/main.dart';

void main() {
  testWidgets('PDCSSSuperviseeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PDCSSSuperviseeApp());
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('Raahnuma Dashboard'), findsWidgets);
  });
}
