import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/widget_reader_painter.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/manager_menu_widget.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:provider/provider.dart';

class NovelPageReader extends BaseStatefulView<NovelReaderViewModel> {
  final bool _isMenuOpen;

  NovelPageReader(this._isMenuOpen,
       Key readerKey)
      : super(
            key: readerKey,);

  @override
  BaseStatefulViewState<NovelPageReader, NovelReaderViewModel> buildState() {
    return _NovelPageReaderState();
  }
}

class _NovelPageReaderState
    extends BaseStatefulViewState<NovelPageReader, NovelReaderViewModel>
    with TickerProviderStateMixin {
  ReaderPageManager pageManager;
  NovelPagePainter mPainter;

  TouchEvent currentTouchEvent = TouchEvent(TouchEvent.ACTION_UP, null);
  AnimationController animationController;

  GlobalKey canvasKey = new GlobalKey();

  _NovelPageReaderState();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget buildView(BuildContext context, NovelReaderViewModel viewModel) {

    if (viewModel?.getCurrentPage()?.pagePicture == null) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else {
      return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          NovelPagePanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              NovelPagePanGestureRecognizer>(
            () => NovelPagePanGestureRecognizer(widget._isMenuOpen),
            (NovelPagePanGestureRecognizer instance) {
              instance.setMenuOpen(widget._isMenuOpen);
              instance
                ..onDown = (detail) {
                  if (currentTouchEvent.action != TouchEvent.ACTION_DOWN ||
                      currentTouchEvent.touchPos != detail.localPosition) {
                    currentTouchEvent = TouchEvent(
                        TouchEvent.ACTION_DOWN, detail.localPosition);
                    mPainter.setCurrentTouchEvent(currentTouchEvent);
                    canvasKey.currentContext
                        .findRenderObject()
                        .markNeedsPaint();
                  }
                };
              instance
                ..onUpdate = (detail) {
                  if (currentTouchEvent.action != TouchEvent.ACTION_MOVE ||
                      currentTouchEvent.touchPos != detail.localPosition) {
                    currentTouchEvent = TouchEvent(
                        TouchEvent.ACTION_MOVE, detail.localPosition);
                    mPainter.setCurrentTouchEvent(currentTouchEvent);
                    canvasKey.currentContext
                        .findRenderObject()
                        .markNeedsPaint();
                  }
                };
              instance
                ..onEnd = (detail) {
                  if (currentTouchEvent.action != TouchEvent.ACTION_UP ||
                      currentTouchEvent.touchPos != Offset(0, 0)) {
                    currentTouchEvent = TouchEvent<DragEndDetails>(
                        TouchEvent.ACTION_UP, Offset(0, 0));
                    currentTouchEvent.touchDetail = detail;

                    mPainter.setCurrentTouchEvent(currentTouchEvent);
                    canvasKey.currentContext
                        .findRenderObject()
                        .markNeedsPaint();
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
  }

  @override
  void initData() {

  }

  @override
  void loadData(BuildContext context, NovelReaderViewModel viewModel) {
    switch (viewModel.getConfigData().currentAnimationMode) {
      case ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN:
      case ReaderPageManager.TYPE_ANIMATION_COVER_TURN:
        animationController = AnimationController(
          vsync: this,
        );
        break;
      case ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN:
        animationController = AnimationController.unbounded(
          vsync: this,
        );
        break;
    }

    if(animationController!=null) {
      pageManager = ReaderPageManager();
      pageManager.setCurrentAnimation(viewModel.getConfigData().currentAnimationMode);
      pageManager.setCurrentCanvasContainerContext(canvasKey);
      pageManager.setAnimationController(animationController);
      pageManager.setContentViewModel(viewModel);

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
