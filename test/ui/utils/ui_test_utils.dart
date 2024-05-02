import 'package:aidex/ui/components/custom_color_picker.dart';
import 'package:aidex/ui/deck-overview/deck_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';

/// Selects a color from the [CustomColorPicker] and closes the dialog.
Future<void> selectColor(
    final WidgetTester tester, final Color colorToSelect) async {
  // expect CustomColorPicker to be visible
  final colorPicker = find.byType(CustomColorPicker);
  expect(colorPicker, findsOneWidget);
  final openColorPickerButton =
      find.byKey(CustomColorPicker.colorPickerButtonKey);
  expect(openColorPickerButton, findsOneWidget);
  await tester.tap(openColorPickerButton);
  await tester.pumpAndSettle();

  // expect block picker to be visible
  final blockPicker = find.byType(BlockPicker);
  expect(blockPicker, findsOneWidget);

  // find container childs of block picker
  final blackContainer = find.descendant(
      of: blockPicker,
      matching: find.byWidgetPredicate((final widget) =>
          (widget is Container) &&
          (widget.decoration is BoxDecoration) &&
          (widget.decoration! as BoxDecoration).color == colorToSelect));
  expect(blackContainer, findsOneWidget);
  final inkWell =
      find.descendant(of: blackContainer, matching: find.byType(InkWell));
  expect(inkWell, findsOneWidget);
  await tester.ensureVisible(inkWell);
  await tester.tap(inkWell);
  await tester.pumpAndSettle();

  // press color picker 'Select' button
  final selectColorButton =
      find.byKey(CustomColorPicker.colorPickerSelectButtonKey);
  expect(selectColorButton, findsOneWidget);
  await tester.tap(selectColorButton);
  await tester.pumpAndSettle();
}

/// Checks the color of a [DeckItemWidget].
void checkColorOfDeck(final int deckId, final Color expectedColor) {
  final Finder deckItemFinder =
      find.byKey(DeckItemWidget.deckItemWidgetKey(deckId));
  final Finder colorIndicatorFinder = find.descendant(
      of: deckItemFinder,
      matching: find.byKey(DeckItemWidget.colorIndicatorKey));
  final FinderResult<Element> colorElements = colorIndicatorFinder.evaluate();
  expect(colorElements.length, 1);
  final Container colorContainer1 =
      colorElements.elementAt(0).widget as Container;
  final BoxDecoration colorBoxDecoration1 =
      colorContainer1.decoration! as BoxDecoration;
  final Border border = colorBoxDecoration1.border! as Border;
  final Color color1 = border.left.color;
  expect(color1, expectedColor);
}
