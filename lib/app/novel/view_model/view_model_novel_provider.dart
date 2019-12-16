import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/model/model_novel_cache.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_db.dart';
import 'package:flutter_novel/app/novel/model/zssq/model_book_net.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelBookProvider extends BaseViewModel {
  NovelBookDBModel _dbBookModel;
  NovelBookNetModel _netBookModel;
  NovelBookCacheModel _cacheModel;

  NovelBookShelfInfo bookshelfInfo = NovelBookShelfInfo();

  NovelBookProvider(this._dbBookModel, this._netBookModel, this._cacheModel);

  @override
  Widget getProviderContainer() {
    return null;
  }

  void getSavedBook() {
    _dbBookModel?.getSavedBook();
    Future<void>.delayed(Duration(seconds: 5)).then((data){
      bookshelfInfo.currentBookShelf= [
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      NovelBookInfo()
      ..cover =
      "http://img.1391.com/api/v1/bookcenter/cover/1/2014980/2014980_713632b9b37d405f84865792cdae14f3.jpg/"
      ..title = "剑来",
      ];
      notifyListeners();
    });
  }

  void getCatalog() {
    _netBookModel?.getCatalog();
  }

  Future<String> getChapterContent() async {
    String result;
    result = await _cacheModel.getChapterContent();

    if (result == null || result.length == 0) {
      result = await _netBookModel.getChapterContent();
      _cacheModel.cacheChapterContent(result);
    }

    return result;
  }

  void getBookIntroduction() {
    _netBookModel?.getBookIntroduction();
  }
}

class NovelBookShelfInfo {
  List<NovelBookInfo> currentBookShelf=[];
}
