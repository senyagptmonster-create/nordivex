import 'package:flutter_test/flutter_test.dart';
import 'package:nordivex/nordivex_app.dart';

void main() {
  testWidgets('NordivexSummitApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NordivexSummitApp());
    expect(find.byType(NordivexSummitApp), findsOneWidget);
  });
}