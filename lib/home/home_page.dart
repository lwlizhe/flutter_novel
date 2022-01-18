import 'package:flutter/material.dart';
import 'package:flutter_novel/base/model/base_model.dart';
import 'package:flutter_novel/base/util/safety_widget.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/base/viewmodel/base_view_model.dart';
import 'package:flutter_novel/home/view/home_recommend_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, SafetyState {
  TabController? _tabController;
  List<BaseView> tabList = [
    HomePageRecommendPage(),
    _HomePagePostPage(),
    _HomePageBookCasePage(),
    _HomePageMyPage()
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: tabList.length, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: TabBarView(
                      controller: _tabController, children: tabList)),
              Container(
                color: Colors.black26,
                child: TabBar(
                  tabs: tabList
                      .map((e) => Text(
                            e.title,
                            style: TextStyle(color: Colors.blue),
                          ))
                      .toList(),
                  controller: _tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomePagePostPage extends BaseView {
  const _HomePagePostPage({Key? key})
      : super(key: key, tag: '_HomePagePostPage');

  @override
  String get title => '帖子';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
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

class _HomePageBookCasePage extends BaseView {
  const _HomePageBookCasePage({Key? key})
      : super(key: key, tag: '_HomePageBookCasePage');

  @override
  String get title => '书架';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
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

class _HomePageMyPage extends BaseView {
  const _HomePageMyPage({Key? key}) : super(key: key, tag: '_HomePageMyPage');

  @override
  String get title => '我的';

  @override
  BaseViewModel buildViewModel() {
    return BaseViewModel();
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
