import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/base/db/manager_db.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper extends BaseDBProvider {
  /// DataBase table name
  static const String TABLE_NAME = "novel_bookshelf";

  static const String COLUMN_ID = "_id";
  static const String COLUMN_BOOK_ID = "bookId";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_CHAPTER_INDEX = "chaptersIndex";
  static const String COLUMN_VOLUME_INDEX = "volumeIndex";
  static const String COLUMN_PAGE_INDEX = "pageIndex";
  static const String COLUMN_IMAGE = "image";

  @override
  String createSql() =>
      baseCreateSql(TABLE_NAME, COLUMN_ID) +
      '''
       $COLUMN_BOOK_ID TEXT not null,
       $COLUMN_TITLE TEXT not null,
       $COLUMN_IMAGE TEXT not null,
       $COLUMN_CHAPTER_INDEX INTEGER not null,
       $COLUMN_VOLUME_INDEX INTEGER not null,
       $COLUMN_PAGE_INDEX INTEGER not null)
      ''';

  @override
  String tableName() => TABLE_NAME;

  /// 根据[bookId]查询某书是否在书架
  /// @return true or false
  ///
  Future<bool> isExist(String bookId) async {
    if (bookId == null) return false;
    Database db = await getDB();
    List<Map<String, dynamic>> maps = await db
        .query(TABLE_NAME, where: "$COLUMN_BOOK_ID = ?", whereArgs: [bookId]);
    return maps.isNotEmpty;
  }

  /// 根据[bookId]查询某书详情
  /// @return book
  ///
  Future<NovelBookInfo> getBook(String bookId) async {
    bool _isExist = await isExist(bookId);
    if (!_isExist) return null;

    List<NovelBookInfo> books = [];
    Database db = await getDB();
    List<Map<String, dynamic>> maps = await db
        .query(TABLE_NAME, where: "$COLUMN_BOOK_ID = ?", whereArgs: [bookId]);
    if (maps.isNotEmpty) {
      for (Map<String, dynamic> map in maps) {
        NovelBookInfo book = NovelBookInfo.fromDBMap(map);
        books.add(book);
      }

      return books.first;
    } else {
      return null;
    }
  }

  /// 根据[_id]查询某书详情
  /// @return book
  ///
  Future<NovelBookInfo> getBookById(int _id) async {
    List<NovelBookInfo> books = [];
    Database db = await getDB();
    List<Map<String, dynamic>> maps =
        await db.query(TABLE_NAME, where: "$COLUMN_ID = ?", whereArgs: [_id]);
    if (maps.isNotEmpty) {
      for (Map<String, dynamic> map in maps) {
        NovelBookInfo book = NovelBookInfo.fromDBMap(map);
        books.add(book);
      }
      return books.first;
    } else {
      return null;
    }
  }

  /// 查询书架上所有小说
  /// @return list
  ///
  Future<List<NovelBookInfo>> getAllBooks() async {
    List<NovelBookInfo> books = [];
    Database db = await getDB();
    List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    if (maps.isNotEmpty) {
      for (Map<String, dynamic> map in maps) {
        NovelBookInfo book = NovelBookInfo.fromDBMap(map);
        books.add(book);
      }
    }
    return books;
  }

  /// 添加小说[book]到书架
  /// @return _id
  ///
  Future<int> insertOrReplaceToDB(NovelBookInfo book) async {
    if (book == null) return -1;
    String id = book?.bookId;
    if (book == null || id == null) return -1;
    bool _isExist = await isExist(id);
    if (!_isExist) {}
    Database db = await getDB();
    Map<String, dynamic> map = book.toDBMap();
    return await db.insert(TABLE_NAME, map);
  }

  /// 跟新书架上的小说信息[book]
  /// @return true or false
  ///
  Future<bool> updateBook(NovelBookInfo book) async {
    String id = book?.bookId;
    if (book == null || id == null) return false;

    bool _isExist = await isExist(id);
    if (!_isExist) return false;
    Database db = await getDB();

    Map<String, dynamic> map = book.toDBMap();
    int result = await db
        .update(TABLE_NAME, map, where: "$COLUMN_BOOK_ID = ?", whereArgs: [id]);

    return result == 1;
  }

  /// 根据[bookId]删除书架上的小说
  /// @return true or false
  ///
  Future<bool> deleteBook(String bookId) async {
    bool _isExist = await isExist(bookId);
    if (!_isExist) return false;
    Database db = await getDB();

    int result = await db
        .delete(TABLE_NAME, where: "$COLUMN_BOOK_ID = ?", whereArgs: [bookId]);

    return result == 1;
  }

  /// 删除书架上的所有小说
  /// @return true or false
  ///
  Future<bool> deleteAllBook() async {
    Database db = await getDB();
    int result = await db.delete(TABLE_NAME);
    return result == 1;
  }
}
