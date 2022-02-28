import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/net/entity_forum_book_review_info.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/forum/view/forum_post_detail_page.dart';
import 'package:flutter_novel/home/viewmodel/home_forum_view_model.dart';
import 'package:flutter_novel/net/constant.dart';
import 'package:get/get.dart';

/// ------------------------------- 论坛整体 ------------------------------------
class HomeForumPage extends StatefulWidget {
  const HomeForumPage({Key? key}) : super(key: key);

  @override
  _HomeForumPageState createState() => _HomeForumPageState();
}

class _HomeForumPageState extends State<HomeForumPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _HomeForumPageContent();
  }

  @override
  bool get wantKeepAlive => true;
}

/// ------------------------------- 论坛内容 ------------------------------------

class _HomeForumPageContent extends BaseView<HomeForumViewModel> {
  @override
  Widget buildContent(BuildContext context, HomeForumViewModel viewModel) {
    return _ForumContentView();
  }

  @override
  HomeForumViewModel buildViewModel() {
    return HomeForumViewModel();
  }
}

/// ------------------------------ loading页 -----------------------------------

class _ForumContentLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            title: Text('loading……'),
          ),
          Expanded(
              child: Container(
            alignment: AlignmentDirectional.center,
            child: Text('loading……'),
          ))
        ],
      ),
    );
  }
}

/// -------------------------------- 内容页 -------------------------------------

class _ForumContentView extends StatefulWidget {
  const _ForumContentView({Key? key}) : super(key: key);

  @override
  _ForumContentViewState createState() => _ForumContentViewState();
}

class _ForumContentViewState extends State<_ForumContentView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: Container(
              constraints: BoxConstraints(maxWidth: 200),
              child:
                  TabBar(controller: tabController, isScrollable: false, tabs: [
                Tab(
                  text: '讨论区',
                ),
                Tab(
                  text: '书评广场',
                )
              ]),
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              _ForumContentDiscussionView(),
              _ForumContentBookReviewView(),
            ],
          ))
        ],
      ),
    );
  }
}

/// ------------------------------ 讨论区内容页 ----------------------------------

class _ForumContentDiscussionView extends StatefulWidget {
  const _ForumContentDiscussionView({Key? key}) : super(key: key);

  @override
  _ForumContentDiscussionViewState createState() =>
      _ForumContentDiscussionViewState();
}

class _ForumContentDiscussionViewState
    extends State<_ForumContentDiscussionView>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _controller;
  late HomeForumViewModel viewModel;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    viewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ObxValue<RxList<ForumPostInfo>>((data) {
      return Container(
        child: EasyRefresh.custom(
          enableControlFinishRefresh: false,
          enableControlFinishLoad: true,
          controller: _controller,
          header: ClassicalHeader(),
          footer: ClassicalFooter(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onRefresh');
              _currentPageIndex = 0;
              viewModel.getDiscussionPostList(_currentPageIndex);
              _controller.resetLoadState();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onLoad');
              _currentPageIndex += 1;
              viewModel.getDiscussionPostList(_currentPageIndex);
              _controller.finishLoad(noMore: false);
            });
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    child: Center(
                      child: _ForumDiscussionItemView(
                        data: data[index],
                      ),
                    ),
                  );
                },
                childCount: data.length,
              ),
            ),
          ],
        ),
      );
    }, viewModel.discussionPostList);
  }

  @override
  bool get wantKeepAlive => true;
}

/// ------------------------------ 讨论页面Item ---------------------------------

class _ForumDiscussionItemView extends StatelessWidget {
  final ForumPostInfo data;

  const _ForumDiscussionItemView({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            //动画时间为500毫秒
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                //使用渐隐渐入过渡,
                opacity: animation,
                child: ForumPostDetailPage(
                  detailType: ForumDetailType.post,
                  detailId: data.id,
                ),
              );
            },
          ),
        );
      },
      child: Container(
        color: Color(0x18FFFFFF),
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: 'http://api.zhuishushenqi.com' +
                        (data.author?.avatar ?? ''),
                    width: 50,
                    height: 50,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(data.author?.nickname ?? ''), Text('time')],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(data.title ?? ''),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: AlignmentDirectional.center,
                  child: Text('点赞icon:${(data.likeCount ?? 0)}'),
                )),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: AlignmentDirectional.center,
                  child: Text('评论icon:${(data.commentCount ?? 0)}'),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// ------------------------------ 书评广场内容页 --------------------------------

class _ForumContentBookReviewView extends StatefulWidget {
  const _ForumContentBookReviewView({Key? key}) : super(key: key);

  @override
  _ForumContentBookReviewViewState createState() =>
      _ForumContentBookReviewViewState();
}

class _ForumContentBookReviewViewState
    extends State<_ForumContentBookReviewView>
    with AutomaticKeepAliveClientMixin {
  late EasyRefreshController _controller;

  late HomeForumViewModel viewModel;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    viewModel = Get.find();

    _currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ObxValue<RxList<ForumBookReviewInfo>>((data) {
      return Container(
        child: EasyRefresh.custom(
          enableControlFinishRefresh: false,
          enableControlFinishLoad: true,
          controller: _controller,
          header: ClassicalHeader(),
          footer: ClassicalFooter(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onRefresh');
              _currentPageIndex = 0;
              viewModel.getBookReviewList(_currentPageIndex);
              _controller.resetLoadState();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 2), () {
              print('onLoad');
              _currentPageIndex += 1;
              viewModel.getBookReviewList(_currentPageIndex);
              _controller.finishLoad(noMore: false);
            });
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    child: Center(
                      child: _ForumBookReviewItemView(
                        data: data[index],
                      ),
                    ),
                  );
                },
                childCount: data.length,
              ),
            ),
          ],
        ),
      );
    }, viewModel.bookReviewList);
  }

  @override
  bool get wantKeepAlive => true;
}

/// ------------------------------ 书评页面Item ---------------------------------

class _ForumBookReviewItemView extends StatelessWidget {
  final ForumBookReviewInfo data;

  const _ForumBookReviewItemView({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0x18FFFFFF),
      margin: EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(data.title ?? ''),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius:
                      BorderRadiusDirectional.all(Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('相关书籍'),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: READER_IMAGE_URL +
                            Uri.decodeComponent(data.book?.cover ?? ''),
                        width: 60,
                        height: 90,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: AlignmentDirectional.center,
                child: Text('点赞icon:'),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 1,
                height: 20,
                color: Colors.grey,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: AlignmentDirectional.center,
                child: Text('评论icon:'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
