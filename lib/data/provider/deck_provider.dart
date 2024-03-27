import 'package:aidex/model/deck.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// The deck data access object.
class DeckProvider {
  /// Private constructor
  DeckProvider._create(this._db);

  /// Public factory
  static Future<DeckProvider> init() async {
    // Open the database
    final db =
        await _getDatabase(join(await getDatabasesPath(), 'aidex_deck.db'));
    return DeckProvider._create(db);
  }

  /// The deck data access object.
  final Database _db;

  /// Opens the database at the given [path].
  static Future<Database> _getDatabase(final String path) async {
    final db = await openDatabase(path, version: 1,
        onCreate: (final db, final version) async {
      await db.execute('''
create table ${Deck.tableDeck} ( 
  ${Deck.columnDeckId} integer primary key autoincrement, 
  ${Deck.columnName} text not null,
  ${Deck.columnColor} integer not null,
  ${Deck.columnCardsCount} integer not null)
''');
    });
    return db;
  }

  /// Returns all decks from the database.
  Future<List<Deck>> getDecks() async {
    final List<Map<String, dynamic>> maps = await _db.query(Deck.tableDeck,
        columns: [
          Deck.columnDeckId,
          Deck.columnName,
          Deck.columnColor,
          Deck.columnCardsCount
        ]);
    return List.generate(maps.length, (final i) => Deck.fromMap(maps[i]));
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

  /// Inserts the given [deck] into the database.
  Future<Deck> insert(final Deck deck) async {
    deck.deckId = await _db.insert(Deck.tableDeck, deck.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return deck;
  }

  /// Returns all decks from the database.
  Future<int> delete(final int id) async => _db.delete(Deck.tableDeck,
      where: '${Deck.columnDeckId} = ?', whereArgs: [id]);

  /// Delete all decks from the database.
  Future<int> deleteAll() async => _db.delete(Deck.tableDeck);

  /// Returns all decks from the database.
  Future<int> update(final Deck deck) async =>
      _db.update(Deck.tableDeck, deck.toMap(),
          where: '${Deck.columnDeckId} = ?', whereArgs: [deck.deckId]);

  /// Closes the database.
  Future close() async => _db.close();
}
