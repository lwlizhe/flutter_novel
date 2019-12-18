import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_db.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookShelfViewModel extends BaseViewModel {
  NovelBookDBModel _dbBookModel;
  NovelBookNetModel _netBookModel;

  NovelBookShelfInfo get bookshelfInfo =>_dbBookModel?.bookshelfInfo;

  NovelBookShelfViewModel(this._dbBookModel, this._netBookModel);

  @override
  Widget getProviderContainer() {
    return null;
  }

  void addBookToShelf(NovelBookInfo book){
    _dbBookModel?.addBook(book);
  }

  void getSavedBook() {
    _dbBookModel?.getSavedBook()?.then((data){
      bookshelfInfo.currentBookShelf=data;
      if(!isDisposed&&hasListeners) {
        notifyListeners();
      }
    });

//    Future<void>.delayed(Duration(seconds: 5)).then((data){
//      bookshelfInfo.currentBookShelf= [
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      NovelBookInfo()
//      ..cover =
//      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
//      ..title = "剑来",
//      ];
//      if(!isDisposed&&hasListeners) {
//        notifyListeners();
//      }
//    });
  }

  void getCatalog() {
    _netBookModel?.getCatalog();
  }

  void getBookIntroduction() {
    _netBookModel?.getBookIntroduction();
  }
}


