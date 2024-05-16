import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                    padding: const EdgeInsets.all(40),
                    child: Opacity(
                      opacity: 0.05,
                      child: SvgPicture.asset(
                        'assets/index-card-view/index-card-view.svg',
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(
                    card.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          back: Card(
              color: const Color(0xFF414141),
              child: Column(children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Opacity(
                          opacity: 0.05,
                          child: SvgPicture.asset(
                            'assets/index-card-view/index-card-view.svg',
                            height: 70,
                            width: 70,
                          ),
                        ))
                  ],
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: AbsorbPointer(
                            child: RichTextEditorWidget(
                          readonly: true,
                          controller: RichTextEditorController(
                              contentJson: card.answer),
                        )))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Opacity(
                          opacity: 0.05,
                          child: SvgPicture.asset(
                            'assets/index-card-view/index-card-view.svg',
                            height: 70,
                            width: 70,
                          ),
                        )),
                  ],
                ),
              ]))));
}
