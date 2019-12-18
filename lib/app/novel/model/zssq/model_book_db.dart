import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/helper/helper_db.dart';
import 'package:flutter_novel/base/structure/base_model.dart';

class NovelBookDBModel extends BaseModel {
  final DBHelper _dbHelper;

  NovelBookShelfInfo bookshelfInfo = NovelBookShelfInfo();

  NovelBookDBModel(this._dbHelper);

  Future<List<NovelBookInfo>> getSavedBook() {
    return _dbHelper.getAllBooks();
  }

  void addBook(NovelBookInfo book){
    _dbHelper.insertOrReplaceToDB(book);
  }

  void getBookInfo() {}
}

class NovelBookShelfInfo {
  List<NovelBookInfo> currentBookShelf = [];
}
