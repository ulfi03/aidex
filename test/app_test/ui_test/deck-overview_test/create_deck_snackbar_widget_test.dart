import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Widget tests -------------------------------------------------------------
  // Widget initializers
  onManual() {}
  onAI() {}
  var widgetStub = MaterialApp(
    home: Scaffold(
      body: CreateDeckSnackbarWidget(onManual: onManual, onAI: onAI),
    ),
  );

  testWidgets('deck_snackbar_widget has correct widget title', (tester) async {
    await tester.pumpWidget(widgetStub);
    final widgetTitle = find.byKey(CreateDeckSnackbarWidget.snackbarTitleKey);
    expect(widgetTitle, findsOneWidget);
  });
  testWidgets('correct title for manual creation of a deck', (tester) async {
    await tester.pumpWidget(widgetStub);
    final manualCreateText =
        find.byKey(CreateDeckSnackbarWidget.createManuallyTitleKey);
    expect(manualCreateText, findsOneWidget);
  });
  testWidgets('correct title for AI driven creation of a deck', (tester) async {
    await tester.pumpWidget(widgetStub);
    final aiCreateText = find.byKey(CreateDeckSnackbarWidget.createAITitleKey);
    expect(aiCreateText, findsOneWidget);
  });

  // [potential] golden  tests -------------------------------------------------------------

  //vgl. https://itnext.io/tdd-in-flutter-part-3-testing-your-widgets-c5e87d76a864
}
