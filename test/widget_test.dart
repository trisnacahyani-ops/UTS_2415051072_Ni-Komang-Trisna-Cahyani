import 'package:flutter_test/flutter_test.dart';
import 'package:colormate/main.dart';

void main() {
  testWidgets('ColorMate app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ColorMateApp());

    expect(find.text('ColorMate'), findsOneWidget);
    expect(find.text('Hello, Designer! 👋'), findsOneWidget);
  });
}
