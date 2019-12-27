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
    if(!bookshelfInfo.currentBookShelf.contains(book)) {
      bookshelfInfo.currentBookShelf.add(book);
    }
  }
  void removeBook(String bookId){
    _dbHelper.deleteBook(bookId).then((isSuccess){
      NovelBookInfo targetBook;
      for(NovelBookInfo bookInfo in bookshelfInfo.currentBookShelf){
        if(bookInfo.bookId==bookId){
          targetBook=bookInfo;
          break;
        }
      }

      if(targetBook!=null) {
        bookshelfInfo.currentBookShelf.remove(targetBook);
      }
    });
  }

  void updateBookInfo(NovelBookInfo book){
    _dbHelper.updateBook(book).then((isSuccess){
      if(isSuccess){
        for(NovelBookInfo bookInfo in bookshelfInfo.currentBookShelf){
          if(bookInfo.bookId==book.bookId){
            bookInfo=book;
            break;
          }
        }
      }
    });

  }

  void getBookInfo() {

  }
}

class NovelBookShelfInfo {
  List<NovelBookInfo> currentBookShelf = [];
}
