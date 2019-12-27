import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/animation/animation_page_base.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/animation/controller_animation_with_listener_number.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';

/// 覆盖动画 ///
class CoverPageAnimation extends BaseAnimationPage {
  static const int ORIENTATION_VERTICAL = 1;
  static const int ORIENTATION_HORIZONTAL = 0;

  bool isTurnNext = true;
  bool isStartAnimation = false;

  int coverDirection = ORIENTATION_VERTICAL;

  Offset mStartPoint = Offset(0, 0);

  Tween<Offset> currentAnimationTween;
  Animation<Offset> currentAnimation;

  ANIMATION_TYPE animationType;

  AnimationStatusListener statusListener;

  @override
  Animation<Offset> getCancelAnimation(
      AnimationController controller, GlobalKey canvasKey) {
    if ((!isTurnNext && !isCanGoPre()) || (isTurnNext && !isCanGoNext())) {
      return null;
    }

    if (currentAnimation == null) {
      buildCurrentAnimation(controller, canvasKey);
    }

    currentAnimationTween.begin = (coverDirection == ORIENTATION_HORIZONTAL)
        ? Offset(mTouch.dx, 0)
        : Offset(0, mTouch.dy);
    currentAnimationTween.end = (coverDirection == ORIENTATION_HORIZONTAL)
        ? Offset(mStartPoint.dx, 0)
        : Offset(0, mStartPoint.dy);

    animationType = ANIMATION_TYPE.TYPE_CANCEL;

    return currentAnimation;
  }

  @override
  Animation<Offset> getConfirmAnimation(
      AnimationController controller, GlobalKey canvasKey) {
    if ((!isTurnNext && !isCanGoPre()) || (isTurnNext && !isCanGoNext())) {
      return null;
    }

    if (currentAnimation == null) {
      buildCurrentAnimation(controller, canvasKey);
    }
    /// 很神奇的一点，这个监听器有时会自己变成null……偶发性的，试了好多次也没找到如何触发的……但它就是存在变成null的情况
    /// 所以要检测一下，变成null了就给它弄回去
    if (statusListener == null) {
      statusListener = (status) {
        switch (status) {
          case AnimationStatus.dismissed:
            break;
          case AnimationStatus.completed:
            if (animationType == ANIMATION_TYPE.TYPE_CONFIRM) {
              if (isTurnNext) {
                readerViewModel.nextPage();
              } else {
                readerViewModel.prePage();
              }
              canvasKey.currentContext.findRenderObject().markNeedsPaint();
            }
            break;
          case AnimationStatus.forward:
          case AnimationStatus.reverse:
            break;
        }
      };
      currentAnimation.addStatusListener(statusListener);
    }

    if(statusListener!=null&&!(controller as AnimationControllerWithListenerNumber).statusListeners.contains(statusListener)){
      currentAnimation.addStatusListener(statusListener);
    }

    currentAnimationTween.begin = (coverDirection == ORIENTATION_HORIZONTAL)
        ? Offset(mTouch.dx, 0)
        : Offset(0, mTouch.dy);
    currentAnimationTween.end = (coverDirection == ORIENTATION_HORIZONTAL)
        ? Offset(
            isTurnNext
                ? mStartPoint.dx - currentSize.width
                : currentSize.width + mStartPoint.dx,
            0)
        : Offset(
            0,
            isTurnNext
                ? mStartPoint.dy - currentSize.height
                : mStartPoint.dy + currentSize.height);

    animationType = ANIMATION_TYPE.TYPE_CONFIRM;

    return currentAnimation;
  }

  @override
  void onDraw(Canvas canvas) {
    if (isStartAnimation && (mTouch.dx != 0 || mTouch.dy != 0)) {
      drawBottomPage(canvas);
      drawCurrentShadow(canvas);
      drawTopPage(canvas);
    } else {
      drawStatic(canvas);
    }

    isStartAnimation = false;
  }

  @override
  void onTouchEvent(TouchEvent event) {
    if (event.touchPos != null) {
      mTouch = event.touchPos;
    }

    switch (event.action) {
      case TouchEvent.ACTION_DOWN:
        mStartPoint = event.touchPos;
        break;
      case TouchEvent.ACTION_MOVE:
      case TouchEvent.ACTION_UP:
      case TouchEvent.ACTION_CANCEL:
        if (coverDirection == ORIENTATION_VERTICAL) {
          isTurnNext = mTouch.dy - mStartPoint.dy < 0;
        } else {
          isTurnNext = mTouch.dx - mStartPoint.dx < 0;
        }

        if ((!isTurnNext && isCanGoPre()) || (isTurnNext && isCanGoNext())) {
          isStartAnimation = true;
        }
        break;
      default:
        break;
    }
  }

  void drawStatic(Canvas canvas) {
    canvas.drawPicture(readerViewModel.getCurrentPage().pagePicture);
  }

  void drawBottomPage(Canvas canvas) {
    canvas.save();
    if (isTurnNext) {
      canvas.drawPicture(readerViewModel.getNextPage().pagePicture);
    } else {
      canvas.drawPicture(readerViewModel.getCurrentPage().pagePicture);
    }
    canvas.restore();
  }

  void drawTopPage(Canvas canvas) {
    canvas.save();
    if (coverDirection == ORIENTATION_HORIZONTAL) {
      if (isTurnNext) {
        canvas.translate(mTouch.dx - mStartPoint.dx, 0);
        canvas.drawPicture(readerViewModel.getCurrentPage().pagePicture);
      } else {
        canvas.translate((mTouch.dx - mStartPoint.dx) - currentSize.width, 0);
        canvas.drawPicture(readerViewModel.getPrePage().pagePicture);
      }
    } else {
      if (isTurnNext) {
        canvas.translate(0, mTouch.dy - mStartPoint.dy);
        canvas.drawPicture(readerViewModel.getCurrentPage().pagePicture);
      } else {
        canvas.translate(0, (mTouch.dy - mStartPoint.dy) - currentSize.height);
        canvas.drawPicture(readerViewModel.getPrePage().pagePicture);
      }
    }
    canvas.restore();
  }

  void drawCurrentShadow(Canvas canvas) {
    canvas.save();

    Gradient shadowGradient;

    if (coverDirection == ORIENTATION_HORIZONTAL) {
      shadowGradient = new LinearGradient(
        colors: [
          Color(0xAA000000),
          Colors.transparent,
        ],
      );
      if (isTurnNext) {
        Rect rect = Rect.fromLTRB(
            currentSize.width + mTouch.dx - mStartPoint.dx,
            0,
            currentSize.width + mTouch.dx - mStartPoint.dx + 20,
            currentSize.height);
        var shadowPaint = Paint()
          ..isAntiAlias = false
          ..style = PaintingStyle.fill //填充
          ..shader = shadowGradient.createShader(rect);

        canvas.drawRect(rect, shadowPaint);
      } else {
        Rect rect = Rect.fromLTRB((mTouch.dx - mStartPoint.dx), 0,
            (mTouch.dx - mStartPoint.dx) + 20, currentSize.height);
        var shadowPaint = Paint()
          ..isAntiAlias = false
          ..style = PaintingStyle.fill //填充
          ..shader = shadowGradient.createShader(rect);

        canvas.drawRect(rect, shadowPaint);
      }
    } else {
      shadowGradient = new LinearGradient(
        begin: Alignment.topRight,
        colors: [
          Color(0xAA000000),
          Colors.transparent,
        ],
      );
      if (isTurnNext) {
        Rect rect = Rect.fromLTRB(
            0,
            currentSize.height - (mStartPoint.dy - mTouch.dy),
            currentSize.width,
            currentSize.height - (mStartPoint.dy - mTouch.dy) + 20);
        var shadowPaint = Paint()
          ..isAntiAlias = false
          ..style = PaintingStyle.fill //填充
          ..shader = shadowGradient.createShader(rect);

        canvas.drawRect(rect, shadowPaint);
      } else {
        Rect rect = Rect.fromLTRB(0, -(mStartPoint.dy - mTouch.dy),
            currentSize.width, -(mStartPoint.dy - mTouch.dy) + 20);
        var shadowPaint = Paint()
          ..isAntiAlias = false
          ..style = PaintingStyle.fill //填充
          ..shader = shadowGradient.createShader(rect);

        canvas.drawRect(rect, shadowPaint);
      }
    }

    canvas.restore();
  }

  @override
  Simulation getFlingAnimationSimulation(
      AnimationController controller, DragEndDetails details) {
    return null;
  }

  @override
  bool isCancelArea() {
    return coverDirection == ORIENTATION_HORIZONTAL
        ? (mTouch.dx - mStartPoint.dx).abs() < (currentSize.width / 4)
        : (mTouch.dy - mStartPoint.dy).abs() < (currentSize.height / 4);
  }

  @override
  bool isConfirmArea() {
    return coverDirection == ORIENTATION_HORIZONTAL
        ? (mTouch.dx - mStartPoint.dx).abs() > (currentSize.width / 4)
        : (mTouch.dy - mStartPoint.dy).abs() > (currentSize.height / 4);
  }

  void buildCurrentAnimation(
      AnimationController controller, GlobalKey canvasKey) {
    currentAnimationTween = Tween(begin: Offset.zero, end: Offset.zero);

    currentAnimation = currentAnimationTween.animate(controller);
  }
}
