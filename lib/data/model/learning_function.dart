import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:aidex/ui/components/rich_text_editor_widget.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class LearningFunction extends StatefulWidget {
  final List<IndexCard> cards;

  LearningFunction({required Key key, required this.cards, required Deck deck})
      : super(key: key);

  @override
  _LearningFunctionState createState() => _LearningFunctionState();
}

class _LearningFunctionState extends State<LearningFunction> {
  int currentIndex = 0;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Opacity(opacity: 0.5, child: Text('Learning Function')),
        ),
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => cardKey.currentState?.toggleCard(),
            ),
            Center(
              child: widget.cards.isEmpty
                  ? Text('No cards available')
                  : Padding(
                      padding: const EdgeInsets.only(
                          bottom: 90.0), // Adjust the padding as needed
                      child: FlipCard(
                        key: ValueKey(currentIndex),
                        fill: Fill.fillFront,
                        // The side to initially display.
                        front: Card(
                            color: Color(0xFF414141),
                            child: Align(
                              child: Text(widget.cards[currentIndex].question,
                                  style: TextStyle(fontSize: 36)),
                            )),
                        back: Card(
                            color: Color(0xFF414141),
                            child: AbsorbPointer(
                                child: RichTextEditorWidget(
                              readonly: true,
                              controller: RichTextEditorController(
                                  contentJson:
                                      widget.cards[currentIndex].answer),
                            ))),
                      ),
                    ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: currentIndex > 0
                                ? Color(0xFF20EFC0)
                                : Colors.grey,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text('Back'),
                        style: TextButton.styleFrom(
                          foregroundColor: currentIndex > 0
                              ? Color(0xFF20EFC0)
                              : Colors.grey,
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  currentIndex--;
                                  if (cardKey.currentState?.isFront == false) {
                                    cardKey.currentState?.toggleCard();
                                  }
                                });
                              }
                            : null,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: currentIndex < widget.cards.length - 1
                                ? Color(0xFF20EFC0)
                                : Colors.grey,
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text('Next'),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              currentIndex < widget.cards.length - 1
                                  ? Color(0xFF20EFC0)
                                  : Colors.grey,
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: currentIndex < widget.cards.length - 1
                            ? () {
                                setState(() {
                                  currentIndex++;
                                  if (cardKey.currentState?.isFront == false) {
                                    cardKey.currentState?.toggleCard();
                                  }
                                });
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
