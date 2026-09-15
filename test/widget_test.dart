import 'package:flutter_test/flutter_test.dart';
import 'package:nordivex/nordivex_app.dart';

void main() {
  testWidgets('NordivexApp carousel smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NordivexApp());
    expect(find.text('NORDIVEX SUMMITS'), findsOneWidget);
    expect(find.text('Alpine Summit Registry'), findsOneWidget);
  });
}
