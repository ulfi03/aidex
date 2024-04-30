import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
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
  ${Deck.columnColor} integer not null);
''');
    }, onConfigure: (final db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    });
    return db;
  }

  /// get single deck
  Future<Deck?> getDeck(final int id) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery('''
      SELECT ${Deck.tableDeck}.${Deck.columnDeckId},
       ${Deck.tableDeck}.${Deck.columnName},
       ${Deck.tableDeck}.${Deck.columnColor},
       COUNT(${IndexCard.tableIndexCard}.${IndexCard.columnIndexCardId}) as ${Deck.cardsCountAlias}
      FROM ${Deck.tableDeck}
      LEFT JOIN ${IndexCard.tableIndexCard}
      ON ${Deck.tableDeck}.${Deck.columnDeckId} = ${IndexCard.tableIndexCard}.${IndexCard.columnDeckId}
      WHERE ${Deck.tableDeck}.${Deck.columnDeckId} = ?
      GROUP BY ${Deck.tableDeck}.${Deck.columnDeckId}
    ''', [id]);
    if (maps.isNotEmpty) {
      return Deck.fromMap(maps.first);
    }
    return null;
  }

  /// get deck with cardcount
  Future<List<Deck>> getDecks() async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery('''
      SELECT ${Deck.tableDeck}.${Deck.columnDeckId},
       ${Deck.tableDeck}.${Deck.columnName},
       ${Deck.tableDeck}.${Deck.columnColor},
       COUNT(${IndexCard.tableIndexCard}.${IndexCard.columnIndexCardId}) as ${Deck.cardsCountAlias}
      FROM ${Deck.tableDeck}
      LEFT JOIN ${IndexCard.tableIndexCard}
      ON ${Deck.tableDeck}.${Deck.columnDeckId} = ${IndexCard.tableIndexCard}.${IndexCard.columnDeckId}
      GROUP BY ${Deck.tableDeck}.${Deck.columnDeckId}
    ''');
    return List.generate(maps.length, (final i) => Deck.fromMap(maps[i]));
  }

  /// Inserts the given [deck] into the database.
  Future<Deck> insert(final Deck deck) async {
    deck.deckId = await _db.insert(Deck.tableDeck, deck.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return deck;
  }
  /// Delete a decks from the database.
  Future<int> delete(final int id) async => _db.delete(Deck.tableDeck,
      where: '${Deck.columnDeckId} = ?', whereArgs: [id]);

  /// Delete all decks from the database.
  Future<int> deleteAll() async => _db.delete(Deck.tableDeck);
  /// Update a decks from the database.
  Future<int> update(final Deck deck) async =>
      _db.update(Deck.tableDeck, deck.toMap(),
          where: '${Deck.columnDeckId} = ?', whereArgs: [deck.deckId]);

  /// Closes the database.
  Future close() async => _db.close();

  /// Renames a deck in the database.
  ///
  /// Takes a deck id as an [int] and a new name as a [String]. The method will
  /// update the deck's name in the database.
  ///
  /// Throws an [Error] if the update operation fails.
  Future<int> renameDeck(final int deckId, final String newName) async =>
      _db.update(
        Deck.tableDeck,
        {Deck.columnName: newName},
        where: '${Deck.columnDeckId} = ?',
        whereArgs: [deckId],
      );

  /// Change the color of a deck in the database.
  Future<int> changeDeckColor(final int deckId, final int newColor) async =>
      _db.update(
        Deck.tableDeck,
        {Deck.columnColor: newColor},
        where: '${Deck.columnDeckId} = ?',
        whereArgs: [deckId],
      );
}
