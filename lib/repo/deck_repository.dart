import 'package:aidex/model/deck.dart';
import 'package:sqflite/sqflite.dart';

/// The deck data access object.
class DeckRepository {
  /// Constructor for the [DeckRepository].
  /// [_db] is the database.
  DeckRepository(this._db);

  /// The deck data access object.
  late final Database _db;

  /*
  Future<List<Deck>> getAllDecks() => db.);

  Future<int> insertDeck(Deck deck) => db.insertDeck(deck);

  Future<int> updateDeck(Deck deck) => db.updateDeck(deck);

  Future<int> deleteDeck(Deck deck) => db.deleteDeck(deck);
   */

  /// Opens the database at the given [path].
  Future open(final String path) async {
    _db = await openDatabase(path, version: 1,
        onCreate: (final db, final version) async {
      await db.execute('''
create table ${Deck.tableDeck} ( 
  ${Deck.columnDeckId} integer primary key autoincrement, 
  ${Deck.columnName} text not null,
  ${Deck.columnColor} text not null,
  ${Deck.columnCardsCount} integer not null)
''');
    });
  }

  /// Inserts the given [deck] into the database.
  Future<Deck> insert(final Deck deck) async {
    deck.deckId = await _db.insert(Deck.tableDeck, deck.toMap());
    return deck;
  }

  /// Returns all decks from the database.
  Future<Deck?> getDeck(final int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(Deck.tableDeck,
        columns: [
          Deck.columnDeckId,
          Deck.columnName,
          Deck.columnColor,
          Deck.columnCardsCount
        ],
        where: '${Deck.columnDeckId} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Deck.fromMap(maps.first);
    }
    return null;
  }

  /// Returns all decks from the database.
  Future<int> delete(final int id) async => _db.delete(Deck.tableDeck,
      where: '${Deck.columnDeckId} = ?', whereArgs: [id]);

  /// Returns all decks from the database.
  Future<int> update(final Deck deck) async =>
      _db.update(Deck.tableDeck, deck.toMap(),
          where: '${Deck.columnDeckId} = ?', whereArgs: [deck.deckId]);

  /// Closes the database.
  Future close() async => _db.close();
}
