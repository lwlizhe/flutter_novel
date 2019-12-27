import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/view/novel_book_reader.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_shelf.dart';
import 'package:flutter_novel/app/router/manager_router.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:flutter_novel/base/util/utils_toast.dart';
import 'package:provider/provider.dart';

class NovelIntroBottomMenuView
    extends BaseStatefulView<NovelBookShelfViewModel> {
  final NovelDetailInfo bookInfo;

  NovelIntroBottomMenuView(this.bookInfo);

  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>, NovelBookShelfViewModel> buildState() {
    return NovelIntroBottomMenuViewState();
  }
}

class NovelIntroBottomMenuViewState extends BaseStatefulViewState<NovelIntroBottomMenuView,NovelBookShelfViewModel>{
  @override
  Widget buildView(BuildContext context, NovelBookShelfViewModel viewModel) {
    if (widget.bookInfo == null) {
      return Container();
    } else {
      List<NovelBookInfo> currentBookShelf =
          viewModel.bookshelfInfo.currentBookShelf;

      NovelBookInfo currentBookInfo = NovelBookInfo()
        ..bookId = widget.bookInfo.id
        ..cover = widget.bookInfo.cover
        ..title = widget.bookInfo.title;
      bool isBookShelfBook = false;

      for (NovelBookInfo info in currentBookShelf) {
        if (widget.bookInfo.id == info.bookId) {
          currentBookInfo = info;
          isBookShelfBook = true;
          break;
        }
      }

      return Container(
        child: Column(
          children: <Widget>[
            Divider(
              height: 1,
              color: Colors.grey[350],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {

                      if(!isBookShelfBook) {
                        viewModel.addBookToShelf(NovelBookInfo()
                          ..bookId = widget.bookInfo.id
                          ..title = widget.bookInfo.title
                          ..cover = Uri.decodeComponent(
                              widget.bookInfo.cover
                                  .split("/agent/")
                                  .last));
                      }else{
                        viewModel.removeBookFromShelf(widget.bookInfo.id);
                      }

                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(isBookShelfBook ? Icons.remove : Icons.add),
                          SizedBox(
                            width: 5,
                          ),
                          Text(isBookShelfBook ? "不追了" : "追书")
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      APPRouter.instance.route(
                          NovelBookReaderView.buildIntent(
                              context,
                              currentBookInfo));
                    },
                    child: Container(
                      color: Colors.green,
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(isBookShelfBook ? "继续阅读" : "开始阅读"),
                            ],
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ToastUtils.showToast("叮~迅雷手机下载助手提示您，作者摸鱼了……虽然这玩意自动缓存");
                    },
                    child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.file_download),
                            SizedBox(
                              width: 5,
                            ),
                            Text("下载")
                          ],
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }

  @override
  NovelBookShelfViewModel buildViewModel(BuildContext context) {
    return NovelBookShelfViewModel(
      Provider.of(context),
      Provider.of(context),
    );
  }

  @override
  void loadData(BuildContext context, NovelBookShelfViewModel viewModel) {}

  @override
  void initData() {
  }
}
