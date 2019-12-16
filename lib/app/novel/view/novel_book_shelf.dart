import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/model/model_novel_cache.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_provider.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:provider/provider.dart';

class NovelBookShelfView extends BaseStatelessView<NovelBookProvider> {
  @override
  Widget buildView(BuildContext context, NovelBookProvider viewModel) {
    var currentBookShelfInfo = viewModel.bookshelfInfo;

    if (currentBookShelfInfo?.currentBookShelf == null ||
        currentBookShelfInfo.currentBookShelf.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: Text("没有内容，点击添加"),
      );
    } else {
      return GridView.builder(
          itemCount: currentBookShelfInfo.currentBookShelf.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 3 / 4),
          itemBuilder: (context, index) {
            return InkWell(
              child: NovelItemWidget(currentBookShelfInfo.currentBookShelf[index]),
              onTap: (){

              },
            );
          });
    }
  }

  @override
  void loadData(BuildContext context, NovelBookProvider viewModel) {
    viewModel?.getSavedBook();
  }

  @override
  NovelBookProvider buildViewModel(BuildContext context) {
    return NovelBookProvider(
        Provider.of(context),
        Provider.of(context),
        NovelBookCacheModel(Provider.of(context)));
  }
}

class NovelItemWidget extends StatefulWidget {
  final NovelBookInfo bookInfo;

  NovelItemWidget(this.bookInfo);

  @override
  _NovelItemWidgetState createState() => _NovelItemWidgetState();

}

class _NovelItemWidgetState extends State<NovelItemWidget> with AutomaticKeepAliveClientMixin {
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
    );  }

  @override
  bool get wantKeepAlive => true;
}

