import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/animation/controller_animation_with_listener_number.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/widget_reader_painter.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/manager_menu_widget.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/app/novel/widget/reader/widget/widget_novel_reader_error.dart';
import 'package:flutter_novel/app/novel/widget/reader/widget/widget_novel_reader_loadding.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:provider/provider.dart';

class NovelPageReader extends BaseStatefulView<NovelReaderViewModel> {
  NovelPageReader(Key readerKey)
      : super(
          key: readerKey,
        );

  @override
  BaseStatefulViewState<NovelPageReader, NovelReaderViewModel> buildState() {
    return _NovelPageReaderState();
  }
}

class _NovelPageReaderState
    extends BaseStatefulViewState<NovelPageReader, NovelReaderViewModel>
    with TickerProviderStateMixin {
  ReaderPageManager? pageManager;
  NovelPagePainter? mPainter;

  TouchEvent currentTouchEvent = TouchEvent(TouchEvent.ACTION_UP, null);
  AnimationController? animationController;

  GlobalKey canvasKey = new GlobalKey();

  _NovelPageReaderState();

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget buildView(BuildContext context, NovelReaderViewModel? viewModel) {
    print("content build");
    return Container(
      color: viewModel?.getConfigData()?.currentCanvasBgColor==null?Color(0xfffff2cc): viewModel!.getConfigData()!.currentCanvasBgColor,
      child: Builder(builder: (context) {
        if (viewModel?.getCurrentPage()?.pagePicture == null) {
          if (viewModel?.getCurrentContentDataValue()?.contentState == null ||
              viewModel!.getCurrentContentDataValue()!.contentState ==
                  ContentState.STATE_NORMAL) {
            return NovelReaderLoadingPageWidget(
                viewModel?.getCurrentContentDataValue());
          } else {
            return NovelReaderErrorPageWidget(
                viewModel?.getCurrentContentDataValue());
          }
        } else {
          return RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              NovelPagePanGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      NovelPagePanGestureRecognizer>(
                () => NovelPagePanGestureRecognizer(false),
                (NovelPagePanGestureRecognizer instance) {
                  instance.setMenuOpen(false);
                  instance
                    ..onDown = (detail) {
                      if (true) {
                        if (currentTouchEvent.action !=
                                TouchEvent.ACTION_DOWN ||
                            currentTouchEvent.touchPos !=
                                detail.localPosition) {
                          currentTouchEvent = TouchEvent(
                              TouchEvent.ACTION_DOWN, detail.localPosition);
                          mPainter!.setCurrentTouchEvent(currentTouchEvent);
                          canvasKey.currentContext!
                              .findRenderObject()!
                              .markNeedsPaint();
                        }
                      }
                    };
                  instance
                    ..onUpdate = (detail) {
                      if (!viewModel!.getMenuOpenState()) {
                        if (currentTouchEvent.action !=
                                TouchEvent.ACTION_MOVE ||
                            currentTouchEvent.touchPos !=
                                detail.localPosition) {
                          currentTouchEvent = TouchEvent(
                              TouchEvent.ACTION_MOVE, detail.localPosition);
                          mPainter!.setCurrentTouchEvent(currentTouchEvent);
                          canvasKey.currentContext!
                              .findRenderObject()!
                              .markNeedsPaint();
                        }
                      }
                    };
                  instance
                    ..onEnd = (detail) {
                      if (!viewModel!.getMenuOpenState()) {
                        if (currentTouchEvent.action != TouchEvent.ACTION_UP ||
                            currentTouchEvent.touchPos != Offset(0, 0)) {
                          currentTouchEvent = TouchEvent<DragEndDetails>(
                              TouchEvent.ACTION_UP, Offset(0, 0));
                          currentTouchEvent.touchDetail = detail;

                          mPainter!.setCurrentTouchEvent(currentTouchEvent);
                          canvasKey.currentContext!
                              .findRenderObject()!
                              .markNeedsPaint();
                        }
                      }
                    };
                },
              ),
            },
            child: CustomPaint(
              key: canvasKey,
              isComplex: true,
              size: Size(window.physicalSize.width, window.physicalSize.width),
              painter: mPainter,
            ),
          );
        }
      }),
    );
  }

  @override
  void initData() {}

  @override
  void loadData(BuildContext context, NovelReaderViewModel? viewModel) {
    switch (viewModel!.getConfigData()!.currentAnimationMode) {
      case ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN:
      case ReaderPageManager.TYPE_ANIMATION_COVER_TURN:
        animationController = AnimationControllerWithListenerNumber(
          vsync: this,
        );
        break;
      case ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN:
        animationController = AnimationControllerWithListenerNumber.unbounded(
          vsync: this,
        );
        break;
    }

    if (animationController != null) {
      pageManager = ReaderPageManager();
      pageManager!
          .setCurrentAnimation(viewModel.getConfigData()!.currentAnimationMode);
      pageManager!.setCurrentCanvasContainerContext(canvasKey);
      pageManager!.setAnimationController(animationController!);
      pageManager!.setContentViewModel(viewModel);

      mPainter = NovelPagePainter(pageManager: pageManager);
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  NovelReaderViewModel buildViewModel(BuildContext context) {
    return Provider.of<NovelReaderViewModel>(context);
  }

  @override
  void didUpdateWidget(NovelPageReader oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool isBindViewModel() {
    return false;
  }
}
