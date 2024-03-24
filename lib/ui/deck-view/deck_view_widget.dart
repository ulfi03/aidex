import 'package:aidex/app/model/deck.dart';
import 'package:aidex/app/model/index_card.dart';
import 'package:flutter/material.dart';

class DeckViewWidget extends StatefulWidget {
  final Deck deck;
  final List<IndexCard> indexCards;

  const DeckViewWidget({Key? key, required this.deck, required this.indexCards}) : super(key: key);

  @override
  _DeckViewWidgetState createState() => _DeckViewWidgetState();
}

class _DeckViewWidgetState extends State<DeckViewWidget> {
  List<IndexCard> indexCards = [];

  @override
  void initState() {
    super.initState();
    indexCards = widget.indexCards;
  }

  Future<void> showCreateIndexCardDialog(final BuildContext context) async {
    var title = '';
    var content = '';
    await showDialog(
      context: context,
      builder: (final context) {
        return StatefulBuilder(
          builder: (final context, final setState) => AlertDialog(
            title: Text('Create Index Card'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Content'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (title.isNotEmpty && content.isNotEmpty) {
                    setState(() {
                      indexCards.add(IndexCard(title: title, content: content));
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showCreateIndexCardDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: indexCards.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(indexCards[index].title),
            onDismissed: (direction) {
              setState(() {
                indexCards.removeAt(index);
              });
              // TODO: Implement functionality to delete the IndexCard
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(indexCards[index].title),
              subtitle: Text(indexCards[index].content),
              onTap: () {
                // TODO: Implement functionality to edit the IndexCard
              },
            ),
          );
        },
      ),
    );
  }
}