import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/common/util.dart';
import 'package:flutter_novel/entity/novel/entity_book_shelf_info.dart';
import 'package:flutter_novel/home/viewmodel/home_book_shelf_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:flutter_novel/novel/view/novel_reader_page.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';

/// ------------------------------- 书架页面整体 -------------------------------
class HomeNovelBookShelfPage extends StatefulWidget {
  const HomeNovelBookShelfPage({Key? key}) : super(key: key);

  @override
  _HomeNovelBookShelfPageState createState() => _HomeNovelBookShelfPageState();
}

class _HomeNovelBookShelfPageState extends State<HomeNovelBookShelfPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _HomeNovelBookShelfContent();
  }

  @override
  bool get wantKeepAlive => true;
}

/// ------------------------------- 书架页面内容 -------------------------------

class _HomeNovelBookShelfContent extends BaseView<HomeNovelBookShelfViewModel> {
  @override
  Widget buildContent(
      BuildContext context, HomeNovelBookShelfViewModel viewModel) {
    return Scaffold(
      endDrawer: Drawer(
        child: Container(),
      ),
      body: Container(
        child: Column(
          children: [
            Builder(builder: (context) {
              return Padding(
                padding: EdgeInsetsDirectional.only(start: 16),
                child: SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Text(
                        '阅读了XX小时',
                      )),
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
            Expanded(child: _NovelBookShelfContent(viewModel.bookShelfInfo))
          ],
        ),
      ),
    );
  }

  @override
  HomeNovelBookShelfViewModel buildViewModel() {
    return HomeNovelBookShelfViewModel();
  }
}

/// ------------------------------- 书架内容 -------------------------------

class _NovelBookShelfContent extends StatelessWidget {
  final NovelBookShelfInfo? bookShelfInfo;

  const _NovelBookShelfContent(this.bookShelfInfo, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (bookShelfInfo == null ||
        (bookShelfInfo?.bookShelfInfoList.isEmpty ?? false)) {
      return buildEmptyWidget();
    }

    return _NovelBookShelfContentWidget(
      bookShelfInfo: bookShelfInfo!,
    );
  }

  Widget buildEmptyWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        '空的',
      ),
    );
  }
}

class _NovelBookShelfContentWidget extends StatefulWidget {
  const _NovelBookShelfContentWidget({Key? key, required this.bookShelfInfo})
      : super(key: key);

  final NovelBookShelfInfo bookShelfInfo;

  @override
  _NovelBookShelfContentWidgetState createState() =>
      _NovelBookShelfContentWidgetState();
}

class _NovelBookShelfContentWidgetState
    extends State<_NovelBookShelfContentWidget> {
  var itemData = <NovelBookShelfBookInfo>[];

  @override
  void initState() {
    super.initState();
    itemData.addAll(widget.bookShelfInfo.bookShelfInfoList);
  }

  @override
  void didUpdateWidget(covariant _NovelBookShelfContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (this.widget.bookShelfInfo != oldWidget.bookShelfInfo) {
      itemData.clear();
      itemData.addAll(widget.bookShelfInfo.bookShelfInfoList);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(20),
      alignment: AlignmentDirectional.topStart,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BookShelfGrid.builder(
            sliverGridKey: GlobalKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3.0 / 4.8,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return AspectRatio(
                aspectRatio: 3.0 / 5.0,
                child: Container(
                  child: _NovelBookShelfItemWidget(itemData[index]),
                ),
              );
            },
            itemCount: itemData.length,
            onReOrder: (toIndex, fromIndex) {
              setState(() {
                itemData.insert(toIndex, itemData.removeAt(fromIndex));
              });
            },
          );
        },
      ),
    );
  }
}

class _NovelBookShelfItemWidget extends StatelessWidget {
  final NovelBookShelfBookInfo itemBookInfo;

  _NovelBookShelfItemWidget(this.itemBookInfo);

  @override
  Widget build(BuildContext context) {
    return buildButton(
        context: context,
        onPressCallback: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              //动画时间为500毫秒
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  //使用渐隐渐入过渡,
                  opacity: animation,
                  child: NovelReaderPage("0"),
                );
              },
            ),
          );
        },
        childWidgetBuilder: (context) {
          return Container(
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadiusDirectional.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white
                                    .withAlpha((255 * 0.25).toInt()),
                                offset: Offset(0.0, 6.0),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: AspectRatio(
                          aspectRatio: 3.0 / 4.0,
                          child: CachedNetworkImage(
                            imageUrl: READER_IMAGE_URL + (itemBookInfo.cover),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${itemBookInfo.title}',
                        maxLines: 1,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
