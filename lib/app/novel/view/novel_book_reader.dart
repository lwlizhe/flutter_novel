import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_info.dart';
import 'package:flutter_novel/app/novel/widget/reader/cache/novel_config_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/widget_reader_content.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/manager_menu_widget.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/widget_reader_bottom_menu.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/widget_reader_catalog_menu.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/widget_reader_setting_menu.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/widget_reader_top_menu.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/app/novel/widget/reader/model/model_reader_config.dart';
import 'package:flutter_novel/app/novel/widget/reader2/content/widget_reader_content.dart';
import 'package:flutter_novel/app/router/manager_router.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/util/utils_screen.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screen/screen.dart';

class NovelBookReaderView extends BaseStatefulView<NovelReaderViewModel> {
  final NovelBookInfo bookInfo;

  NovelBookReaderView(this.bookInfo);

  static APPRouterRequestOption buildIntent(
      BuildContext context, NovelBookInfo bookInfo) {
    return APPRouterRequestOption(APPRouter.ROUTER_NAME_NOVEL_READER, context,
        params: {
          "bookInfo": bookInfo,
        });
  }

  static NovelBookReaderView getPageView(APPRouterRequestOption option) {
    return NovelBookReaderView(option.params["bookInfo"]);
  }

  @override
  BaseStatefulViewState<NovelBookReaderView, NovelReaderViewModel>
      buildState() {
    return _NovelReaderPageState();
  }
}

class _NovelReaderPageState
    extends BaseStatefulViewState<NovelBookReaderView, NovelReaderViewModel>
    with TickerProviderStateMixin {
  GlobalKey readerKey = new GlobalKey();
  GlobalKey bottomMenuKey = new GlobalKey();

  ReaderConfigEntity configData;
  NovelConfigManager _configManager;

  AnimationController _controller;
  bool _isMenuOpen = false;

  NovelMenuState currentMenuState = NovelMenuState.STATE_SHOW_NORMAL;

  PublishSubject<NovelMenuState> _menuStreamSubject;

  _NovelReaderPageState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initData() {
    _controller = NovelMenuManager.createAnimationController(this);
    this.configData = ReaderConfigEntity();

    _menuStreamSubject = PublishSubject();

    initConfig();
  }

  @override
  void loadData(BuildContext context, NovelReaderViewModel viewModel) {
//    print("ScreenHeight:"+MediaQuery.of(context).size.height.toString());
//    print("ScreenWidth:"+MediaQuery.of(context).size.width.toString());
    configData
      ..currentPageIndex = widget.bookInfo.currentPageIndex
      ..currentChapterIndex = widget.bookInfo.currentChapterIndex
      ..novelId = widget.bookInfo.bookId
      ..pageSize =
          Offset(ScreenUtils.getScreenWidth(), ScreenUtils.getScreenHeight());

    viewModel.setCurrentConfig(configData);

    viewModel.requestCatalog(widget.bookInfo.bookId);
  }

  @override
  Widget buildView(BuildContext context, NovelReaderViewModel viewModel) {

    viewModel.setPageSize(Offset(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));

    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                toggleMenu((isOpen) {
                  if (!isOpen) {
                    currentMenuState = NovelMenuState.STATE_SHOW_NORMAL;
                    _menuStreamSubject.add(currentMenuState);
                  }
                });
              },
              child: RepaintBoundary(
                child: NovelPageReader2(readerKey),
              ),
            ),
          ]..addAll(buildMenus(viewModel)),
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _menuStreamSubject?.close();
  }

  void initConfig() async {
    _configManager = NovelConfigManager();

    Screen.setBrightness(await _configManager.getUserBrightnessConfig());
    int animationMode = await _configManager.getUserConfigAnimationMode();
    int fontSize = await _configManager.getUserFontSizeConfig();
    int lineHeight = await _configManager.getUserLineHeightConfig();
    int paragraphSpacing = await _configManager.getUserParagraphSpacingConfig();
    Color bgColor = await _configManager.getUserConfigBgColor();

    if (animationMode != null) {
      this.configData..currentAnimationMode = animationMode;
    } else {
      _configManager.setUserConfigAnimationMode(
          ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN);
      this.configData
        ..currentAnimationMode =
            ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN;
    }

    if (fontSize != null) {
      this.configData..fontSize = fontSize;
    } else {
      _configManager
          .setUserFontSizeConfig(NovelConfigManager.VALUE_DEFAULT_FONT_SIZE);
      this.configData..fontSize = NovelConfigManager.VALUE_DEFAULT_FONT_SIZE;
    }

    if (lineHeight != null) {
      this.configData..lineHeight = lineHeight;
    } else {
      _configManager.setUserLineHeightConfig(
          NovelConfigManager.VALUE_DEFAULT_LINE_HEIGHT);
      this.configData
        ..lineHeight = NovelConfigManager.VALUE_DEFAULT_LINE_HEIGHT;
    }

    if (paragraphSpacing != null) {
      this.configData..paragraphSpacing = paragraphSpacing;
    } else {
      _configManager.setUserParagraphSpacingConfig(
          NovelConfigManager.VALUE_DEFAULT_PARAGRAPH_SPACING);
      this.configData
        ..paragraphSpacing = NovelConfigManager.VALUE_DEFAULT_PARAGRAPH_SPACING;
    }

    if (bgColor != null) {
      this.configData..currentCanvasBgColor = bgColor;
    } else {
      _configManager.setUserConfigBgColor(Color(0xfffff2cc));
      this.configData..currentCanvasBgColor = Color(0xfffff2cc);
    }

    viewModel.setCurrentConfig(configData);
  }

  void setConfig(ReaderConfigEntity data) {
    viewModel?.setCurrentConfig(configData);

    setState(() {
      this.configData = data;
    });
  }

  void toggleMenu(Function finishCallback) {
    if (!_isMenuOpen) {
      _controller.forward(from: 0).then((finish) {
        if (finishCallback != null) {
          finishCallback(true);
        }
      });
    } else {
      _controller.reverse(from: 1).then((finish) {
        if (finishCallback != null) {
          finishCallback(false);
        }
      });
    }
    _isMenuOpen = !_isMenuOpen;
    viewModel.setMenuOpenState(_isMenuOpen);
  }

  void refreshReader() {
//    viewModel.notifyRefresh();
    readerKey.currentContext.findRenderObject().markNeedsPaint();
  }

  Widget getBottomSettingMenu(NovelReaderViewModel viewModel) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomSingleChildLayout(
          delegate: NovelMenuLayoutDelegate(
              _controller.value, MenuDirection.DIRECTION_BOTTOM),
          child: NovelSettingMenu((type, data) {
            switch (type) {
              case MenuOperateEnum.OPERATE_SETTING_FONT_SIZE:
                if (configData.fontSize != data) {
                  configData..fontSize = data;
                  viewModel.setFontSize(data);
                  refreshReader();
                }
                break;
              case MenuOperateEnum.OPERATE_SETTING_LINE_HEIGHT:
                if (configData.lineHeight != data) {
                  configData..lineHeight = data;
                  viewModel.setLineHeight(data);
                  refreshReader();
                }
                break;
              case MenuOperateEnum.OPERATE_SETTING_PARAGRAPH_SPACING:
                if (configData.paragraphSpacing != data) {
                  configData..paragraphSpacing = data;
                  viewModel.setParagraphSpacing(data);
                  refreshReader();
                }
                break;
              case MenuOperateEnum.OPERATE_SETTING_ANIMATION_MODE:
                if (configData.currentAnimationMode != data) {
                  configData..currentAnimationMode = data;
                  viewModel.setAnimationMode(data);
                  refreshReader();
                }
                break;
              case MenuOperateEnum.OPERATE_SETTING_BG_COLOR:
                if (configData.currentCanvasBgColor.value != data.value) {
                  configData..currentCanvasBgColor = data;
                  viewModel.setBgColor(data);
                  refreshReader();
                }
                break;
              default:
                break;
            }
          }),
        );
      },
    );
  }

  Widget getTopNormalMenu(NovelReaderViewModel viewModel) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomSingleChildLayout(
          delegate: NovelMenuLayoutDelegate(
              _controller.value, MenuDirection.DIRECTION_TOP),
          child: NovelTopMenu(),
        );
      },
    );
  }

  Widget getBottomNormalMenu(NovelReaderViewModel viewModel) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomSingleChildLayout(
          delegate: NovelMenuLayoutDelegate(
              _controller.value, MenuDirection.DIRECTION_BOTTOM),
          child: NovelBottomMenu(viewModel.getCurrentContentDataValue(),
              (type, data) {
            switch (type) {
              case MenuOperateEnum.OPERATE_NEXT_CHAPTER:
                toggleMenu(null);
                viewModel.goToNextChapter().then((result) {
                  if (result) {
                    refreshReader();
                  }
                });
                break;
              case MenuOperateEnum.OPERATE_PRE_CHAPTER:
                toggleMenu(null);
                viewModel.goToPreChapter().then((result) {
                  if (result) {
                    refreshReader();
                  }
                });
                break;
              case MenuOperateEnum.OPERATE_JUMP_CHAPTER:
                viewModel.goToTargetPage(data).then((result) {
                  if (result) {
                    refreshReader();
                  }
                });
                break;
              case MenuOperateEnum.OPERATE_OPEN_CATALOG:
                toggleMenu((isOpen) {
                  if (!isOpen) {
                    currentMenuState = NovelMenuState.STATE_SHOW_CATALOG;
                    _menuStreamSubject.add(currentMenuState);
                    toggleMenu(null);
                  }
                });
                break;
              case MenuOperateEnum.OPERATE_OPEN_SETTING:
                toggleMenu((isOpen) {
                  if (!isOpen) {
                    currentMenuState = NovelMenuState.STATE_SHOW_SETTING;
                    _menuStreamSubject.add(currentMenuState);
                    toggleMenu(null);
                  }
                });
                break;
              case MenuOperateEnum.OPERATE_TOGGLE_NIGHT_MODE:
                toggleMenu(null);
                break;
              default:
                break;
            }
          }, bottomMenuKey),
        );
      },
    );
  }

  Widget getCatalogMenu(NovelReaderViewModel viewModel) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomSingleChildLayout(
          delegate: NovelMenuLayoutDelegate(
              _controller.value, MenuDirection.DIRECTION_LEFT),
          child: NovelCatalogMenu(viewModel.getCatalog(),
              viewModel.getCurrentContentDataValue().chapterIndex,
              (type, data) {
            switch (type) {
              case MenuOperateEnum.OPERATE_SELECT_CHAPTER:
                toggleMenu((isOpen) {
                  if (!isOpen) {
                    currentMenuState = NovelMenuState.STATE_SHOW_NORMAL;
                    _menuStreamSubject.add(currentMenuState);
                  }
                });
                viewModel.goToTargetChapter(data).then((result) {
                  if (result) {
                    refreshReader();
                  }
                });
                break;
              default:
                break;
            }
          }, bottomMenuKey),
        );
      },
    );
  }

  List<Widget> buildMenus(NovelReaderViewModel viewModel) {
    List<Widget> menuWidget = [];

    menuWidget.add(StreamBuilder(
        stream: _menuStreamSubject.stream,
        builder: ((context, AsyncSnapshot<NovelMenuState> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case NovelMenuState.STATE_SHOW_NORMAL:
                return getBottomNormalMenu(viewModel);
                break;
              case NovelMenuState.STATE_SHOW_CATALOG:
                return getCatalogMenu(viewModel);
                break;
              case NovelMenuState.STATE_SHOW_SETTING:
                return getBottomSettingMenu(viewModel);
                break;
              default:
                return Container();
                break;
            }
          } else {
            return getBottomNormalMenu(viewModel);
          }
        })));

    menuWidget.add(StreamBuilder(
        stream: _menuStreamSubject.stream,
        builder: ((context, AsyncSnapshot<NovelMenuState> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case NovelMenuState.STATE_SHOW_NORMAL:
                return getTopNormalMenu(viewModel);
                break;
              default:
                return Container();
                break;
            }
          } else {
            return getTopNormalMenu(viewModel);
          }
        })));

//    menuWidget.add(getBottomNormalMenu(viewModel));
//    menuWidget.add(getTopNormalMenu(viewModel));
//    menuWidget.add(getBottomSettingMenu(viewModel));

//    switch (currentMenuState) {
//      case NovelMenuState.STATE_SHOW_NORMAL:
//        menuWidget.add(getBottomNormalMenu(viewModel));
//        menuWidget.add(getTopNormalMenu(viewModel));
//        break;
//      case NovelMenuState.STATE_SHOW_CATALOG:
//        break;
//      case NovelMenuState.STATE_SHOW_SETTING:
//        menuWidget.add(getBottomSettingMenu(viewModel));
//        break;
//    }

    return menuWidget;
  }

  @override
  NovelReaderViewModel buildViewModel(BuildContext context) {
    return NovelReaderViewModel(widget.bookInfo, Provider.of(context),
        Provider.of(context), Provider.of(context));
  }
}

enum NovelMenuState {
  STATE_SHOW_NORMAL,
  STATE_SHOW_CATALOG,
  STATE_SHOW_SETTING
}
