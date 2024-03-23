import 'package:aidex/ui/deck-overview/create_deck_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// void functions to trigger CreateDeckSnackbarWidget
  void onManual() {}
  void onAI() {}

  ///initialize the CreateDeckSnackbarWidget
  final widgetStub = MaterialApp(
    home: Scaffold(
      body: CreateDeckSnackbarWidget(onManual: onManual, onAI: onAI),
    ),
  );

  testWidgets('deck_snackbar_widget has correct widget title',
      (final tester) async {
    await tester.pumpWidget(widgetStub);
    final widgetTitle = find.byKey(CreateDeckSnackbarWidget.snackbarTitleKey);
    expect(widgetTitle, findsOneWidget);
  });
  testWidgets('correct title for manual creation of a deck',
      (final tester) async {
    await tester.pumpWidget(widgetStub);
    final manualCreateText =
        find.byKey(CreateDeckSnackbarWidget.createManuallyTitleKey);
    expect(manualCreateText, findsOneWidget);
  });

  testWidgets('correct title for AI driven creation of a deck',
      (final tester) async {
    await tester.pumpWidget(widgetStub);
    final aiCreateText = find.byKey(CreateDeckSnackbarWidget.createAITitleKey);
    expect(aiCreateText, findsOneWidget);
  });
}
