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

  /// The deck data access object.
  final Database _db;

  /// Opens the database at the given [path].
  static Future<Database> _getDatabase(final String path) async {
    final db = await openDatabase(path, version: 1,
        onCreate: (final db, final version) async {
      await db.execute('''
create table ${IndexCard.tableIndexCard} (
  ${IndexCard.columnIndexCardId} integer primary key autoincrement,
  ${IndexCard.columnTitle} text not null,
  ${IndexCard.columnContentJson} text not null,
  ${IndexCard.columnDeckId} integer not null)
      ''');
    });
    return db;
  }

  /// Returns all index cards from the database.
  Future<List<IndexCard>> getIndexCards() async {
    final List<Map<String, dynamic>> maps =
        await _db.query(IndexCard.tableIndexCard, columns: [
      IndexCard.columnIndexCardId,
      IndexCard.columnTitle,
      IndexCard.columnContentJson,
      IndexCard.columnDeckId
    ]);
    return List.generate(maps.length, (final i) => IndexCard.fromMap(maps[i]));
  }

  /// Returns one index cards from the database.
  Future<IndexCard?> getIndexCard(final int id) async {
    final List<Map<String, dynamic>> maps =
        await _db.query(IndexCard.tableIndexCard,
            columns: [
              IndexCard.columnIndexCardId,
              IndexCard.columnTitle,
              IndexCard.columnContentJson,
              IndexCard.columnDeckId
            ],
            where: '${IndexCard.columnIndexCardId} = ?',
            whereArgs: [id]);
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
  Future<int> deleteAll() async => _db.delete(IndexCard.tableIndexCard);

  /// update one IndexCard from the database.
  Future<int> update(final IndexCard indexCard) async =>
      _db.update(IndexCard.tableIndexCard, indexCard.toMap(),
          where: '${IndexCard.columnIndexCardId} = ?',
          whereArgs: [indexCard.indexCardId]);

  /// Closes the database.
  Future close() async => _db.close();
}
