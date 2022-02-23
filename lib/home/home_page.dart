import 'package:flutter/material.dart';
import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/base/util/safety_widget.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/home/view/forum/home_forum_view.dart';
import 'package:flutter_novel/home/view/recommend/home_recommend_view.dart';
import 'package:flutter_novel/home/view/shelf/home_book_shelf_view.dart';
import 'package:flutter_novel/home/viewmodel/home_book_shelf_view_model.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, SafetyState {
  TabController? _tabController;
  List<Widget> tabList = [
    HomePageRecommendPage(),
    HomeForumPage(),
    HomeNovelBookShelfPage(),
    _HomePageMyPage()
  ];

  List<String> tabNameList = ['推荐', '帖子', '书架', '我的'];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: tabList.length, initialIndex: 0, vsync: this);

    /// 全局共享的ViewModel
    Get.put(HomeNovelBookShelfViewModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: tabList)),
              Container(
                child: TabBar(
                  tabs: tabNameList
                      .map((e) => Container(
                            alignment: AlignmentDirectional.center,
                            height: 40,
                            child: Text(
                              e,
                            ),
                          ))
                      .toList(),
                  controller: _tabController,
                  onTap: (index) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePageMyPage extends BaseView {
  const _HomePageMyPage({Key? key}) : super(key: key, tag: '_HomePageMyPage');

  @override
  String get title => '我的';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel(model: null);
  }

  @override
  Widget buildContent(
      BuildContext context, BaseViewModel<BaseModel> viewModel) {
    return Container(
      alignment: Alignment.center,
      child: Text(title),
    );
  }
}
