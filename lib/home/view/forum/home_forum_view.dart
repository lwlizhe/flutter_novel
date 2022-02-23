import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/home/viewmodel/home_forum_view_model.dart';

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
            physics: NeverScrollableScrollPhysics(),
          ))
        ],
      ),
    );
  }
}

class _ForumContentDiscussionView extends StatelessWidget {
  const _ForumContentDiscussionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text('讨论区'),
    );
  }
}

class _ForumContentBookReviewView extends StatelessWidget {
  const _ForumContentBookReviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text('书评广场'),
    );
  }
}
