import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/view/novel_book_intro.dart';
import 'package:flutter_novel/app/novel/view/novel_book_reader.dart';
import 'package:flutter_novel/app/novel/view/novel_book_search.dart';
import 'package:flutter_novel/app/novel/view/novel_book_search_result.dart';
import 'package:flutter_novel/app/novel/view/novel_book_leader_board.dart';
import 'package:flutter_novel/base/router/base_router_manager.dart';

class APPRouter extends BaseRouterManager {
  static const String ROUTER_NAME_NOVEL_INTRO = "app://novel/intro";
  static const String ROUTER_NAME_NOVEL_SEARCH = "app://novel/search";
  static const String ROUTER_NAME_NOVEL_SEARCH_RESULT = "app://novel/search_result";
  static const String ROUTER_NAME_NOVEL_READER = "app://novel/reader";
  static const String ROUTER_NAME_NOVEL_LEADER_BOARD = "app://novel/leader_board";

// 工厂模式 : 单例公开访问点
  factory APPRouter() => _getInstance();

  static APPRouter get instance => _getInstance();

  // 静态私有成员，没有初始化
  static APPRouter _instance;

  // 私有构造函数
  APPRouter._internal() {
    // 初始化
  }

  // 静态、同步、私有访问点
  static APPRouter _getInstance() {
    if (_instance == null) {
      _instance = new APPRouter._internal();
    }
    return _instance;
  }


  void route(APPRouterRequestOption option) {
    if (option == null) {
      return;
    }

    switch (option.targetName) {
      case ROUTER_NAME_NOVEL_INTRO:
        jumpToTarget(option, NovelBookIntroView.getPageView(option));
        break;
      case ROUTER_NAME_NOVEL_SEARCH:
        jumpToTarget(option, NovelSearchView.getPageView());
        break;
      case ROUTER_NAME_NOVEL_SEARCH_RESULT:
        jumpToTarget(option, NovelSearchResultView.getPageView(option));
        break;
      case ROUTER_NAME_NOVEL_READER:
        jumpToTarget(option, NovelBookReaderView.getPageView(option));
        break;
      case ROUTER_NAME_NOVEL_LEADER_BOARD:
        jumpToTarget(option, NovelLeaderBoardView.getPageView(option));
        break;
    }
  }
}

class APPRouterRequestOption extends RouterRequestOption {
  Map<String, dynamic> params;

  APPRouterRequestOption(String targetName, BuildContext context, {this.params})
      : super(targetName, context);
}
