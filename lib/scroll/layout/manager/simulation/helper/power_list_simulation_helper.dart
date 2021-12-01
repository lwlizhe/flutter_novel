import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SimulationTurnPagePainterHelper {
  Offset? mTouch = Offset.zero;
  Size currentSize = Size.zero;

  Offset mBezierStart1 = Offset.zero; // 贝塞尔曲线起始点
  Offset mBezierControl1 = Offset.zero; // 贝塞尔曲线控制点
  Offset mBezierVertex1 = Offset.zero; // 贝塞尔曲线顶点
  Offset mBezierEnd1 = Offset.zero; // 贝塞尔曲线结束点

  Offset mBezierStart2 = Offset.zero; // 另一条贝塞尔曲线
  Offset mBezierControl2 = Offset.zero;
  Offset mBezierVertex2 = Offset.zero;
  Offset mBezierEnd2 = Offset.zero;

  double mCornerX = 1; // 拖拽点对应的页脚
  double mCornerY = 1;

  late bool mIsRTandLB; // 是否属于右上左下

  late double mMiddleX;
  late double mMiddleY;
  double? mDegrees;
  late double mTouchToCornerDis;

  late double mMaxLength;

  Path mTopPagePath = Path();
  Path mBottomPagePath = Path();
  Path mTopBackAreaPagePath = Path();
  Path mShadowPath = Path();

  bool isNeedCalCorner = true;
  bool isTurnNext = false;
  Offset lastTouchPointOffset = Offset.zero;

  void dispatchPointerEvent(
      PointerEvent pointerEvent, RenderBox item, double itemMainAxisDelta) {
    Offset touchPoint = Offset(
        itemMainAxisDelta == 0
            ? item.size.width
            : item.size.width + itemMainAxisDelta,
        pointerEvent.localPosition.dy);

    lastTouchPointOffset = pointerEvent.localPosition;

    if (pointerEvent is PointerMoveEvent) {
      if (isNeedCalCorner) {
        calcCornerXY(touchPoint.dy);
        isNeedCalCorner = false;
        isTurnNext = pointerEvent.delta.dx <= 0;
      }
    }

    if (pointerEvent is PointerUpEvent || pointerEvent is PointerCancelEvent) {
      isNeedCalCorner = true;
    }

    if (!nearEqual(touchPoint.dx, pointerEvent.localPosition.dx,
        1.0 / WidgetsBinding.instance!.window.devicePixelRatio)) {
      /// 如果是由itemMainDelta改变导致的paint，而手势仍是up或者cancel，那么肯定就就是自动恢复动画触发的
      /// 那么按比例将dy 改到CornerY，恢复默认值
      touchPoint = calNewDy(touchPoint, item);
    }

    mTouch = touchPoint;
    calBezierPoint();
  }

  void calBezierPoint() {
    mMiddleX = (mTouch!.dx + mCornerX) / 2;
    mMiddleY = (mTouch!.dy + mCornerY) / 2;

    mMaxLength = sqrt(pow(currentSize.width, 2) + pow(currentSize.height, 2));

    mBezierControl1 = Offset(
        mMiddleX -
            (mCornerY - mMiddleY) *
                (mCornerY - mMiddleY) /
                (mCornerX - mMiddleX),
        mCornerY.toDouble());

    double f4 = mCornerY - mMiddleY;
    if (f4 == 0) {
      mBezierControl2 = Offset(mCornerX.toDouble(),
          mMiddleY - (mCornerX - mMiddleX) * (mCornerX - mMiddleX) / 0.1);
    } else {
      mBezierControl2 = Offset(
          mCornerX.toDouble(),
          mMiddleY -
              (mCornerX - mMiddleX) *
                  (mCornerX - mMiddleX) /
                  (mCornerY - mMiddleY));
    }

    mBezierStart1 = Offset(
        mBezierControl1.dx - (mCornerX - mBezierControl1.dx) / 2,
        mCornerY.toDouble());

    // 当mBezierStart1.x < 0或者mBezierStart1.x > 480时
    // 如果继续翻页，会出现BUG故在此限制
    if (mTouch!.dx > 0 && mTouch!.dx < currentSize.width) {
      if (mBezierStart1.dx < 0 || mBezierStart1.dx > currentSize.width) {
        if (mBezierStart1.dx < 0) {
          mBezierStart1 =
              Offset(currentSize.width - mBezierStart1.dx, mBezierStart1.dy);
        }

        double f1 = (mCornerX - mTouch!.dx).abs();
        double f2 = currentSize.width * f1 / mBezierStart1.dx;
        mTouch = Offset((mCornerX - f2).abs(), mTouch!.dy);

        double f3 =
            (mCornerX - mTouch!.dx).abs() * (mCornerY - mTouch!.dy).abs() / f1;
        mTouch = Offset((mCornerX - f2).abs(), (mCornerY - f3).abs());

        mMiddleX = (mTouch!.dx + mCornerX) / 2;
        mMiddleY = (mTouch!.dy + mCornerY) / 2;

        mBezierControl1 = Offset(
            mMiddleX -
                (mCornerY - mMiddleY) *
                    (mCornerY - mMiddleY) /
                    (mCornerX - mMiddleX),
            mCornerY);

        double f5 = mCornerY - mMiddleY;
        if (f5 == 0) {
          mBezierControl2 = Offset(mCornerX,
              mMiddleY - (mCornerX - mMiddleX) * (mCornerX - mMiddleX) / 0.1);
        } else {
          mBezierControl2 = Offset(
              mCornerX,
              mMiddleY -
                  (mCornerX - mMiddleX) *
                      (mCornerX - mMiddleX) /
                      (mCornerY - mMiddleY));
        }

        mBezierStart1 = Offset(
            mBezierControl1.dx - (mCornerX - mBezierControl1.dx) / 2,
            mBezierStart1.dy);
      }
    }

    mBezierStart2 = Offset(mCornerX.toDouble(),
        mBezierControl2.dy - (mCornerY - mBezierControl2.dy) / 2);

    mTouchToCornerDis =
        sqrt(pow((mTouch!.dx - mCornerX), 2) + pow((mTouch!.dy - mCornerY), 2));

    mBezierEnd1 =
        getCross(mTouch!, mBezierControl1, mBezierStart1, mBezierStart2);
    mBezierEnd2 =
        getCross(mTouch!, mBezierControl2, mBezierStart1, mBezierStart2);

    mBezierVertex1 = Offset(
        (mBezierStart1.dx + 2 * mBezierControl1.dx + mBezierEnd1.dx) / 4,
        (2 * mBezierControl1.dy + mBezierStart1.dy + mBezierEnd1.dy) / 4);

    mBezierVertex2 = Offset(
        (mBezierStart2.dx + 2 * mBezierControl2.dx + mBezierEnd2.dx) / 4,
        (2 * mBezierControl2.dy + mBezierStart2.dy + mBezierEnd2.dy) / 4);
  }

  /// 获取交点 ///
  Offset getCross(Offset p1, Offset p2, Offset p3, Offset p4) {
    // 二元函数通式： y=kx+b(k是斜率)
    double k1 = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    double b1 = ((p1.dx * p2.dy) - (p2.dx * p1.dy)) / (p1.dx - p2.dx);

    double k2 = (p4.dy - p3.dy) / (p4.dx - p3.dx);
    double b2 = ((p3.dx * p4.dy) - (p4.dx * p3.dy)) / (p3.dx - p4.dx);

    return Offset((b2 - b1) / (k1 - k2), k1 * ((b2 - b1) / (k1 - k2)) + b1);
  }

  /// 计算拖拽点对应的拖拽脚 ///
  void calcCornerXY(double y) {
    mCornerX = currentSize.width;

    if (y <= currentSize.height / 2) {
      mCornerY = 0;
    } else {
      mCornerY = currentSize.height;
    }

    if ((mCornerX == 0 && mCornerY == currentSize.height) ||
        (mCornerX == currentSize.width && mCornerY == 0)) {
      mIsRTandLB = true;
    } else {
      mIsRTandLB = false;
    }
  }

  /// 清除翻起来的部分
  void clearBottomCanvasArea(Canvas canvas) {
    mBottomPagePath.reset();
    mBottomPagePath.moveTo(mCornerX, mCornerY);
    mBottomPagePath.lineTo(mBezierStart1.dx, mBezierStart1.dy);
    mBottomPagePath.quadraticBezierTo(
        mBezierControl1.dx, mBezierControl1.dy, mBezierEnd1.dx, mBezierEnd1.dy);
    mBottomPagePath.lineTo(mTouch?.dx ?? 0, mTouch?.dy ?? 0);
    mBottomPagePath.lineTo(mBezierEnd2.dx, mBezierEnd2.dy);
    mBottomPagePath.quadraticBezierTo(mBezierControl2.dx, mBezierControl2.dy,
        mBezierStart2.dx, mBezierStart2.dy);
    mBottomPagePath.close();

    canvas.clipPath(mBottomPagePath, doAntiAlias: false);
    canvas.drawColor(Colors.transparent, BlendMode.src);
  }

  Offset calNewDy(Offset touchPoint, RenderBox item) {
    var isConfirmAnimation = isTurnNext
        ? touchPoint.dx > lastTouchPointOffset.dx
        : touchPoint.dx < lastTouchPointOffset.dx;

    var dxEndTarget = isTurnNext
        ? (isConfirmAnimation ? item.size.width : 0)
        : (isConfirmAnimation ? 0 : item.size.width);

    var percent = ((touchPoint.dx - lastTouchPointOffset.dx) /
        (dxEndTarget - lastTouchPointOffset.dx));
    var newDy = percent * (mCornerY - lastTouchPointOffset.dy) +
        lastTouchPointOffset.dy;
    var result = Offset(touchPoint.dx, newDy);

    print(
        'event after up : cornerX is $mCornerX , cornerY is $mCornerY , dxEndTarget is $dxEndTarget , currentTouch is $result , lastTouch is $lastTouchPointOffset, percent is $percent , newDy is $newDy');

    return result;
  }
}
