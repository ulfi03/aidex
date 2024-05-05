import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

/// A custom flip card widget that displays a question on the front and an
class CustomFlipCard extends StatelessWidget {
  /// Creates a new instance of [CustomFlipCard].
  const CustomFlipCard({required this.card, super.key});

  /// The index card to display.
  final IndexCard card;

  @override
  Widget build(final BuildContext context) => Container(
        constraints: const BoxConstraints.expand(),
        child: FlipCard(
            key: ValueKey(card),
            fill: Fill.fillFront,
            // The side to initially display.
            front: Card(
                color: const Color(0xFF414141),
                child: Align(
                  child:
                      Text(card.question, style: const TextStyle(fontSize: 36)),
                )),
            back: Card(
                color: const Color(0xFF414141),
                child: AbsorbPointer(
                    child: RichTextEditorWidget(
                  readonly: true,
                  controller:
                      RichTextEditorController(contentJson: card.answer),
                )))),
      );
}
