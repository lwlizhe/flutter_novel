import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/novel/entity_book_shelf_info.dart';
import 'package:flutter_novel/home/viewmodel/home_book_shelf_view_model.dart';
import 'package:flutter_novel/net/constant.dart';

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
        color: Theme.of(context).backgroundColor,
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
                        style: TextStyle(color: Colors.white),
                      )),
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
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

    return Container(
      color: Colors.white12,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: READER_IMAGE_URL +
                      (bookShelfInfo!.bookShelfInfoList[index].cover ?? ''),
                  fit: BoxFit.cover,
                )
              ],
            ),
          );
        },
        itemCount: bookShelfInfo!.bookShelfInfoList.length,
      ),
    );
  }

  Widget buildEmptyWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        '空的',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
