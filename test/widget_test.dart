// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:aidex/main.dart';
import 'package:aidex/ui/deck-overview/deck_overview_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (final tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    // Verify that the DeckOverviewWidget is present
    expect(find.byType(DeckOverviewWidget), findsOneWidget);
  });
}
