import 'package:flutter_test/flutter_test.dart';
import 'package:azkar_muslim/main.dart';

void main() {
  testWidgets('App loads home screen successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('أذكار المسلم'), findsOneWidget);
  });
}
