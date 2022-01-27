import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/entity/novel/entity_book_shelf_info.dart';
import 'package:flutter_novel/home/model/home_novel_book_shelf_model.dart';

class HomeNovelBookShelfViewModel
    extends BaseViewModel<HomeNovelBookShelfModel> {
  HomeNovelBookShelfViewModel() : super(model: HomeNovelBookShelfModel());

  NovelBookShelfInfo? bookShelfInfo;

  @override
  void onReady() {
    super.onReady();
    getBookShelfInfo();
  }

  void getBookShelfInfo() async {
    var bookShelfInfo = await model?.getBookShelfInfo();
    this.bookShelfInfo = bookShelfInfo;
    refresh();
  }

  void addBook(NovelBookShelfBookInfo bookInfo) async {
    var bookShelfInfo =
        (await model?.getBookShelfInfo()) ?? NovelBookShelfInfo();

    bookShelfInfo.bookShelfInfoList.add(bookInfo);
    this.bookShelfInfo = bookShelfInfo;
    saveBookShelfInfo(this.bookShelfInfo!);
    refresh();
  }

  void removeBook(NovelBookShelfBookInfo bookInfo) async {
    var bookShelfInfo =
        (await model?.getBookShelfInfo()) ?? NovelBookShelfInfo();

    bookShelfInfo.bookShelfInfoList.remove(bookInfo);
    this.bookShelfInfo = bookShelfInfo;
    saveBookShelfInfo(this.bookShelfInfo!);
    refresh();
  }

  void saveBookShelfInfo(NovelBookShelfInfo info) {
    model?.cacheBookShelfInfo(info);
  }
}
