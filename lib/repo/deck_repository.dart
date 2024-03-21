import 'package:aidex/model/deck.dart';
import 'package:sqflite/sqflite.dart';

/// The deck data access object.
class DeckRepository {
  DeckRepository._create() {
    print("_create() (private constructor)");
  }

  /// Public factory
  static Future<DeckRepository> create() async {
    print("create() (public factory)");

    // Call the private constructor
    final component = DeckRepository._create();

    // Open the database
    try {
      if (_db != null) {
        print('Database already opened');
      } else {
        await _open('aidex_deck.db');
      }
      // drop database 'aidex_deck.db'
      // print('drop database');
      //await deleteDatabase('aidex_deck.db');
    } on Exception catch (e) {
      print('Error opening database: $e');
    }
    // Delete the database and try again
    // Return the fully initialized object
    print('returning component from create()');
    return component;
  }

  /// The deck data access object.
  static Database? _db;

  /// Opens the database at the given [path].
  static Future _open(final String path) async {
    print('_open() in repo');
    _db = await openDatabase(path, version: 1,
        onCreate: (final db, final version) async {
      print('Creating database...');
      await db.execute('''
create table ${Deck.tableDeck} ( 
  ${Deck.columnDeckId} integer primary key autoincrement, 
  ${Deck.columnName} text not null,
  ${Deck.columnColor} integer not null,
  ${Deck.columnCardsCount} integer not null)
''');
      print('Database created');
    });
    if (_db!.isOpen) {
      print('Database opened');
    } else {
      print('Database not opened');
    }
  }

  /// Returns all decks from the database.
  Future<List<Deck>> getDecks() async {
    print('getDecks() in repo');
    final List<Map<String, dynamic>> maps = await _db!.query(Deck.tableDeck,
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
    final List<Map<String, dynamic>> maps = await _db!.query(Deck.tableDeck,
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
    deck.deckId = await _db!.insert(Deck.tableDeck, deck.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return deck;
  }

  /// Returns all decks from the database.
  Future<int> delete(final int id) async => _db!.delete(Deck.tableDeck,
      where: '${Deck.columnDeckId} = ?', whereArgs: [id]);

  /// Returns all decks from the database.
  Future<int> update(final Deck deck) async =>
      _db!.update(Deck.tableDeck, deck.toMap(),
          where: '${Deck.columnDeckId} = ?', whereArgs: [deck.deckId]);

  /// Closes the database.
  Future close() async => _db!.close();
}
