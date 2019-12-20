import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/animation/animation_page_base.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';

/// 滑动动画 ///
/// ps 正在研究怎么加上惯性 (ScrollPhysics:可滑动组件的滑动控制器,android 对应：ClampingScrollPhysics，ScrollController呢？)///
/// AnimationController 有fling动画，不过需要传入滑动距离
/// ScrollPhysics 提供了滑动信息，createBallisticSimulation 方法需要传入一个position(初始化的时候创建) 和 velocity(手势监听的DragEndDetails中有速度)
/// 实在不行直接用小部件实现？
///
/// 结论：自己算个毛，交给模拟器实现去……
class SlidePageAnimation extends BaseAnimationPage {
  ClampingScrollPhysics physics;

  Offset mStartPoint = Offset(0, 0);
  double mStartDy = 0;
  double currentMoveDy = 0;

  /// 滑动偏移量
  double dy = 0;

  /// 上次滑动的index
  int lastIndex = 0;

  /// 翻到下一页
  bool isTurnToNext = true;

  AnimationController _currentAnimationController;

  Tween<Offset> currentAnimationTween;
  Animation<Offset> currentAnimation;

  SlidePageAnimation() : super() {
    physics = ClampingScrollPhysics();
  }

  @override
  void setContentViewModel(NovelReaderViewModel viewModel) {
    super.setContentViewModel(viewModel);
    viewModel.registerContentOperateCallback((operate){
      mStartPoint = Offset(0, 0);
      mStartDy = 0;
      dy = 0;
      lastIndex = 0;
      currentMoveDy = 0;
    });
  }

  @override
  Animation<Offset> getCancelAnimation(
      AnimationController controller, GlobalKey canvasKey) {
    return null;
  }

  @override
  Animation<Offset> getConfirmAnimation(
      AnimationController controller, GlobalKey canvasKey) {
    return null;
  }

  @override
  Simulation getFlingAnimationSimulation(
      AnimationController controller, DragEndDetails details) {
    ClampingScrollSimulation simulation;
    simulation = ClampingScrollSimulation(
      position: mTouch.dy,
      velocity: details.velocity.pixelsPerSecond.dy,
      tolerance: Tolerance.defaultTolerance,
    );
    _currentAnimationController = controller;
    return simulation;
  }

  @override
  void onDraw(Canvas canvas) {
    drawBottomPage(canvas);
  }

  @override
  void onTouchEvent(TouchEvent event) {
    if (event.touchPos == null) {
      return;
    }

    switch (event.action) {
      case TouchEvent.ACTION_DOWN:
        if (!dy.isNaN && !dy.isInfinite) {
          mStartPoint = event.touchPos;
          mStartDy = currentMoveDy;
          dy = 0;
        }

        break;
      case TouchEvent.ACTION_MOVE:
        if (!mTouch.dy.isInfinite && !mStartPoint.dy.isInfinite) {
          double tempDy = event.touchPos.dy - mStartPoint.dy;
          if (!currentSize.height.isInfinite &&
              currentSize.height != 0 &&
              currentSize.height != null &&
              !dy.isInfinite &&
              !currentMoveDy.isInfinite) {
            int currentIndex = (tempDy + mStartDy) ~/ currentSize.height;

            if (lastIndex != currentIndex) {
              if (currentIndex < lastIndex) {
                if (isCanGoNext()) {
                  readerViewModel.nextPage();
                } else {
                  return;
                }
              } else if (currentIndex + 1 > lastIndex) {
                if (isCanGoPre()) {
                  readerViewModel.prePage();
                } else {
                  return;
                }
              }
            }

            mTouch = event.touchPos;
            dy = mTouch.dy - mStartPoint.dy;
            isTurnToNext = mTouch.dy - mStartPoint.dy < 0;
            lastIndex = currentIndex;
            if (!dy.isInfinite && !currentMoveDy.isInfinite) {
              currentMoveDy = mStartDy + dy;
            }
          }
        }
        break;
      case TouchEvent.ACTION_UP:
      case TouchEvent.ACTION_CANCEL:
        break;
      default:
        break;
    }
  }

  @override
  bool isShouldAnimatingInterrupt() {
    return true;
  }

  void drawBottomPage(Canvas canvas) {
    double actualOffset = currentMoveDy < 0
        ? -((currentMoveDy).abs() % currentSize.height)
        : (currentMoveDy) % currentSize.height;

    canvas.save();
    if (actualOffset < 0) {
      if (readerViewModel.getNextPage()?.pagePicture != null) {
        canvas.translate(0, actualOffset + currentSize.height);
        canvas.drawPicture(readerViewModel.getNextPage().pagePicture);
      } else {
        if (!isCanGoNext()) {
          dy = 0;
          actualOffset = 0;
          currentMoveDy = 0;

          if (_currentAnimationController != null &&
              !_currentAnimationController.isCompleted) {
            _currentAnimationController.stop();
          }
        }
      }
    } else if (actualOffset > 0) {
      if (readerViewModel.getPrePage()?.pagePicture != null) {
        canvas.translate(0, actualOffset - currentSize.height);
        canvas.drawPicture(readerViewModel.getPrePage().pagePicture);
      } else {
        if (!isCanGoPre()) {
          dy = 0;
          lastIndex = 0;
          actualOffset = 0;
          currentMoveDy = 0;

          if (_currentAnimationController != null &&
              !_currentAnimationController.isCompleted) {
            _currentAnimationController.stop();
          }
        }
      }
    }

    canvas.restore();
    canvas.save();

    if (readerViewModel.getCurrentPage().pagePicture != null) {
      canvas.translate(0, actualOffset);
      canvas.drawPicture(readerViewModel.getCurrentPage().pagePicture);
    }

    canvas.restore();
  }

  void drawStatic(Canvas canvas) {}

  @override
  bool isCancelArea() {
    return null;
  }

  @override
  bool isConfirmArea() {
    return null;
  }
}
