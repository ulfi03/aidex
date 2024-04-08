import 'dart:async';

import 'package:aidex/data/model/deck.dart';
import 'package:aidex/data/model/index_card.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// The index card data acces object.
class IndexCardProvider {
  /// Private constructor
  IndexCardProvider._create(this._db);

  /// Public factory
  static Future<IndexCardProvider> init() async {
    // Open the database
    final db =
        await _getDatabase(join(await getDatabasesPath(), 'aidex_deck.db'));
    return IndexCardProvider._create(db);
  }

  static Future<void> _createTable(final Database db) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS ${IndexCard.tableIndexCard} (
  ${IndexCard.columnIndexCardId} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${IndexCard.columnQuestion} TEXT NOT NULL,
  ${IndexCard.columnAnswer} TEXT NOT NULL,
  ${IndexCard.columnDeckId} INTEGER NOT NULL,
  FOREIGN KEY (${IndexCard.columnDeckId}) REFERENCES ${Deck.tableDeck} (${Deck.columnDeckId}) ON DELETE CASCADE 
  ) 
      ''');
  }

  /// The deck data access object.
  final Database _db;

  /// Opens the database at the given [path].
  static Future<Database> _getDatabase(final String path) async {
    final db = await openDatabase(path, version: 1);
    await _createTable(db);
    return db;
  }

  /// Returns all index cards from the database.
  Future<List<IndexCard>> getIndexCards(final int deckId) async {
    final List<Map<String, dynamic>> maps =
        await _db.query(IndexCard.tableIndexCard,
            columns: [
              IndexCard.columnIndexCardId,
              IndexCard.columnQuestion,
              IndexCard.columnAnswer,
              IndexCard.columnDeckId
            ],
            where: '${IndexCard.columnDeckId} = ?',
            whereArgs: [deckId]);
    return List.generate(maps.length, (final i) => IndexCard.fromMap(maps[i]));
  }

  /// Returns one index cards from the database.
  Future<IndexCard?> getIndexCard(final int cardId) async {
    final List<Map<String, dynamic>> maps =
        await _db.query(IndexCard.tableIndexCard,
            columns: [
              IndexCard.columnIndexCardId,
              IndexCard.columnQuestion,
              IndexCard.columnAnswer,
              IndexCard.columnDeckId
            ],
            where: '${IndexCard.columnIndexCardId} = ? ',
            whereArgs: [cardId]);
    if (maps.isNotEmpty) {
      return IndexCard.fromMap(maps.first);
    }
    return null;
  }

  /// Inserts the given [indexCard] into the database.
  Future<IndexCard> insert(final IndexCard indexCard) async {
    indexCard.indexCardId = await _db.insert(
        IndexCard.tableIndexCard, indexCard.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return indexCard;
  }

  /// delete one IndexCard from the database.
  Future<int> delete(final int id) async => _db.delete(IndexCard.tableIndexCard,
      where: '${IndexCard.columnIndexCardId} = ?', whereArgs: [id]);

  /// delete all IndexCards from the database.
  Future<int> deleteAll(final int deckId) async =>
      _db.delete(IndexCard.tableIndexCard,
          where: '${IndexCard.columnDeckId} = ?', whereArgs: [deckId]);

  /// update one IndexCard from the database.
  Future<int> update(final IndexCard indexCard) async =>
      _db.update(IndexCard.tableIndexCard, indexCard.toMap(),
          where: '${IndexCard.columnIndexCardId} = ?',
          whereArgs: [indexCard.indexCardId]);

  /// Closes the database.
  Future close() async => _db.close();
}
