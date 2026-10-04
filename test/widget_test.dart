import 'package:flutter_test/flutter_test.dart';
import 'package:sifir/app.dart';

void main() {
  testWidgets('SifirApp builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const SifirApp());
    expect(find.byType(SifirApp), findsOneWidget);
  });
}
