import 'package:aidex/data/model/deck.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'index_card.dart';

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
          title: Text('Learning Function'),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
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
                  : FlipCard(
                      key: cardKey,
                      direction: FlipDirection.HORIZONTAL, // default
                      front: Container(
                        child: Text(
                          widget.cards[currentIndex].question,
                          style: TextStyle(
                            fontSize: 16, // set the font size to 16
                          ),
                          textAlign: TextAlign.center, // center the text
                        ),
                      ),
                      back: Container(
                        child: Text(
                          widget.cards[currentIndex].answer,
                          style: TextStyle(
                            fontSize: 16, // set the font size to 16
                          ),
                          textAlign: TextAlign.center, // center the text
                        ),
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
                        border: Border.all(color: Color(0xFF20EFC0), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text('Back'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF20EFC0),
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
                                });
                              }
                            : null,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF20EFC0), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text('Next'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color(0xFF20EFC0),
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
