import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/view/novel_book_reader.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_shelf.dart';
import 'package:flutter_novel/app/router/manager_router.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:provider/provider.dart';

class NovelBookShelfView extends BaseStatelessView<NovelBookShelfViewModel> {
  @override
  Widget buildView(BuildContext context, NovelBookShelfViewModel viewModel) {
    var currentBookShelfInfo = viewModel.bookshelfInfo;

    if (currentBookShelfInfo?.currentBookShelf == null ||
        currentBookShelfInfo.currentBookShelf.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: InkWell(
          child: Text("没有内容，点击搜索添加"),
          onTap: () {
            APPRouter.instance.route(APPRouterRequestOption(
                APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
          },
        ),
      );
    } else {
      return GridView.builder(
          itemCount: currentBookShelfInfo.currentBookShelf.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 3 / 4),
          itemBuilder: (context, index) {
            if (index <= currentBookShelfInfo.currentBookShelf.length - 1) {
              return Container(
                color: Colors.white,
                child: InkWell(
                  child: NovelItemWidget(
                      currentBookShelfInfo.currentBookShelf[index]),
                  onTap: () {
                    var currentBookShelf =
                        currentBookShelfInfo.currentBookShelf[index];
                    APPRouter.instance.route(NovelBookReaderView.buildIntent(
                        context,
                        currentBookShelf));
                  },
                ),
              );
            } else {
              return Container(
                color: Colors.white,
                child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      APPRouter.instance.route(APPRouterRequestOption(
                          APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
                    }),
              );
            }
          });
    }
  }

  @override
  void loadData(BuildContext context, NovelBookShelfViewModel viewModel) {
    viewModel?.getSavedBook();
  }

  @override
  NovelBookShelfViewModel buildViewModel(BuildContext context) {
    return NovelBookShelfViewModel(
      Provider.of(context),
      Provider.of(context),
    );
  }
}

class NovelItemWidget extends StatefulWidget {
  final NovelBookInfo bookInfo;

  NovelItemWidget(this.bookInfo);

  @override
  _NovelItemWidgetState createState() => _NovelItemWidgetState();
}

class _NovelItemWidgetState extends State<NovelItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Flexible(
            flex: 1,
            child: CachedNetworkImage(
              imageUrl: widget.bookInfo.cover,
              fit: BoxFit.cover,
              fadeOutDuration: new Duration(seconds: 1),
              fadeInDuration: new Duration(seconds: 1),
            ),
          ),
          Text(widget.bookInfo.title)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
