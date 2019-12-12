import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_novel/app/novel/view/novel_book_search.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';
import 'package:flutter_novel/base/util/utils_toast.dart';

class MainPageView extends BaseStatefulView {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>, BaseViewModel>
      buildState() {
    return MainPageViewState();
  }
}

class MainPageViewState
    extends BaseStatefulViewState<MainPageView, BaseViewModel>
    with SingleTickerProviderStateMixin {
  DateTime _lastClickTime;

  TabController primaryTC;

  @override
  void initData() {
    primaryTC = TabController(length: 3, vsync: this);

  }

  @override
  Widget buildView(BuildContext context, BaseViewModel viewModel) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Novel"),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: "书库",
            ),
            Tab(
              text: "发现",
            ),
            Tab(
              text: "关于",
            )
          ],
          controller: primaryTC,
        ),
        actions: <Widget>[
          Padding(
            child: Icon(Icons.search),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
          Padding(
            child: Icon(Icons.menu),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: WillPopScope(
          child: Container(
            child: TabBarView(
              children: [
                NovelSearchView(),
//                NovelBookShelfView(),
                Text("找书部分，其实就是个列表"),
                Text("我的部分，简单描述下这个项目，贴个跳转")
              ],
              controller: primaryTC,
            ),
          ),
          onWillPop: () async {
            if (_lastClickTime == null ||
                DateTime.now().difference(_lastClickTime) >
                    Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              _lastClickTime = DateTime.now();
              ToastUtils.showToast("再次点击退出应用");
              return false;
            }
            return true;
          }),
    );
  }

  @override
  void loadData(BuildContext context, BaseViewModel viewModel) {}

  @override
  BaseViewModel buildViewModel(BuildContext context) {
    return null;
  }
}
