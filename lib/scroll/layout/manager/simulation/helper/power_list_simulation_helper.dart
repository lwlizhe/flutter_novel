import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

class SimulationTurnPagePainterHelper {
  Offset mTouch = Offset.zero;
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

  late double mMiddleX;
  late double mMiddleY;
  double? mDegrees;
  late double mTouchToCornerDis;

  late double mMaxLength;

  // Path mTopPagePath = Path();
  Path mBottomPagePath = Path();
  Path mTopBackAreaPagePath = Path();

  // Path mShadowPath = Path();

  bool isNeedCalCorner = true;
  bool isTurnNext = false;
  Offset lastTouchPointOffset = Offset.zero;

  Paint shadowPainter = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;

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

  void draw(
      PaintingContext context, ContainerLayer currentLayer, RenderBox child) {
    context.paintChild(child, Offset.zero);

    calPath();

    // drawShadowOfTopPage(context, child);
    clearBottomCanvasArea(context, child);
    drawBackSideOfTopPage(context, child);
    // drawShadowOfBackSide(context, child);
  }

  /// 计算贝塞尔曲线的各个关键点坐标
  void calBezierPoint() {
    mMiddleX = (mTouch.dx + mCornerX) / 2;
    mMiddleY = (mTouch.dy + mCornerY) / 2;

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
    if (mTouch.dx > 0 && mTouch.dx < currentSize.width) {
      if (mBezierStart1.dx < 0 || mBezierStart1.dx > currentSize.width) {
        if (mBezierStart1.dx < 0) {
          mBezierStart1 =
              Offset(currentSize.width - mBezierStart1.dx, mBezierStart1.dy);
        }

        double f1 = (mCornerX - mTouch.dx).abs();
        double f2 = currentSize.width * f1 / mBezierStart1.dx;
        mTouch = Offset((mCornerX - f2).abs(), mTouch.dy);

        double f3 =
            (mCornerX - mTouch.dx).abs() * (mCornerY - mTouch.dy).abs() / f1;
        mTouch = Offset((mCornerX - f2).abs(), (mCornerY - f3).abs());

        mMiddleX = (mTouch.dx + mCornerX) / 2;
        mMiddleY = (mTouch.dy + mCornerY) / 2;

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
        sqrt(pow((mTouch.dx - mCornerX), 2) + pow((mTouch.dy - mCornerY), 2));

    mBezierEnd1 =
        getCrossByPoint(mTouch, mBezierControl1, mBezierStart1, mBezierStart2);
    mBezierEnd2 =
        getCrossByPoint(mTouch, mBezierControl2, mBezierStart1, mBezierStart2);

    mBezierVertex1 = Offset(
        (mBezierStart1.dx + 2 * mBezierControl1.dx + mBezierEnd1.dx) / 4,
        (2 * mBezierControl1.dy + mBezierStart1.dy + mBezierEnd1.dy) / 4);

    mBezierVertex2 = Offset(
        (mBezierStart2.dx + 2 * mBezierControl2.dx + mBezierEnd2.dx) / 4,
        (2 * mBezierControl2.dy + mBezierStart2.dy + mBezierEnd2.dy) / 4);
  }

  /// 获取动画过程中应该设置的dy值
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

    return result;
  }

  /// 获取交点(根据四点) ///
  Offset getCrossByPoint(Offset p1, Offset p2, Offset p3, Offset p4) {
    var line1Info = getLineInfo(p1, p2);
    var line2Info = getLineInfo(p3, p4);

    return getCrossByLine(
        line1Info.dx, line1Info.dy, line2Info.dx, line2Info.dy);
  }

  /// 根据k和b
  Offset getCrossByLine(double k1, double b1, double k2, double b2) {
    return Offset((b2 - b1) / (k1 - k2), k1 * ((b2 - b1) / (k1 - k2)) + b1);
  }

  /// 根据两点获取直线的k、b；
  /// return : dx = k，dy = b
  Offset getLineInfo(Offset p1, Offset p2) {
    double k1 = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    double b1 = ((p1.dx * p2.dy) - (p2.dx * p1.dy)) / (p1.dx - p2.dx);
    return Offset(k1, b1);
  }

  double getDistanceOfTwoPoint(Offset p1, Offset p2) {
    double result = 0;

    result = sqrt(pow(p2.dy - p1.dy, 2) + pow(p2.dx - p1.dx, 2));

    return result;
  }

  /// 计算拖拽点对应的拖拽脚 ///
  void calcCornerXY(double y) {
    mCornerX = currentSize.width;
    if (y <= currentSize.height / 2) {
      mCornerY = 0;
    } else {
      mCornerY = currentSize.height;
    }
  }

  /// 清除不需要显示的部分（即下一页的部分）
  void clearBottomCanvasArea(PaintingContext context, RenderBox child) {
    var canvas = context.canvas;

    canvas.save();

    canvas.clipPath(mBottomPagePath, doAntiAlias: false);
    canvas.drawColor(Colors.transparent, BlendMode.src);

    canvas.restore();
  }

  /// 绘制顶层页的阴影部分
  void drawShadowOfTopPage(PaintingContext context, RenderBox child) {
    /// 顶部页面的shadow分两部分：
    /// 翻起部分的投影
    /// 整体阴影

    _drawShadowOfTopPageBackAre(context, child);
    _drawShadowOfTopPageAll(context, child);
  }

  void _drawShadowOfTopPageBackAre(PaintingContext context, RenderBox child) {
    /// 假设两条贝塞尔曲线的顶点，各自平行于其终点到触摸点的直线为l1，l2；
    /// 那么目标直线为平行于l1，l2,且到l1,l2的距离等于顶点到l1,l2距离的一半；
    /// k = 终点到触摸点的直线的k，带入自己这个点即可得到 b
    /// 由两条直线即可得到交点，
    /// 连接交点和两个贝塞尔的顶点，画上阴影色，被挖掉之后就是阴影效果

    var line1Info = getLineInfo(mTouch, mBezierEnd1);
    var line2Info = getLineInfo(mTouch, mBezierEnd2);
    var lineVertexInfo = getLineInfo(mBezierVertex1, mBezierVertex2);

    var bv1 = mBezierVertex1.dy - line1Info.dx * mBezierVertex1.dx;
    var bv2 = mBezierVertex2.dy - line2Info.dx * mBezierVertex2.dx;

    var targetBv1 = (bv1 + line1Info.dy) / 2;
    var targetBv2 = (bv2 + line2Info.dy) / 2;

    var shadowCornerPoint =
        getCrossByLine(line1Info.dx, targetBv1, line2Info.dx, targetBv2);

    var shadowLine1ShadowCrossPoint = getCrossByLine(
        line1Info.dx, targetBv1, lineVertexInfo.dx, lineVertexInfo.dy);
    var shadowLine1CrossPoint = getCrossByLine(
        line1Info.dx, line1Info.dy, lineVertexInfo.dx, lineVertexInfo.dy);

    var shadowLine2ShadowCrossPoint = getCrossByLine(
        line2Info.dx, targetBv2, lineVertexInfo.dx, lineVertexInfo.dy);
    var shadowLine2CrossPoint = getCrossByLine(
        line2Info.dx, line2Info.dy, lineVertexInfo.dx, lineVertexInfo.dy);

    var shadow1path = Path();
    shadow1path.moveTo(shadowCornerPoint.dx, shadowCornerPoint.dy);
    shadow1path.lineTo(mTouch.dx, mTouch.dy);
    shadow1path.lineTo(shadowLine1CrossPoint.dx, shadowLine1CrossPoint.dy);
    shadow1path.lineTo(
        shadowLine1ShadowCrossPoint.dx, shadowLine1ShadowCrossPoint.dy);
    shadow1path.close();

    context.canvas.drawPath(shadow1path, shadowPainter);

    var shadow2path = Path();
    shadow2path.moveTo(shadowCornerPoint.dx, shadowCornerPoint.dy);
    shadow2path.lineTo(mTouch.dx, mTouch.dy);
    shadow2path.lineTo(shadowLine2CrossPoint.dx, shadowLine2CrossPoint.dy);
    shadow2path.lineTo(
        shadowLine2ShadowCrossPoint.dx, shadowLine2ShadowCrossPoint.dy);
    shadow2path.close();

    context.canvas.drawPath(shadow2path, shadowPainter);
  }

  void _drawShadowOfTopPageAll(PaintingContext context, RenderBox child) {}

  /// 绘制顶层翻过来的背面部分
  void drawBackSideOfTopPage(PaintingContext context, RenderBox child) {
    /// 思路：沿着两条贝塞尔曲线控制点的那条直线，进行一次缩放（翻转）
    /// 而上面这步所做的事即为先翻转一次
    /// 然后平移至触摸点
    /// 然后以角落为中心旋转
    /// 角度等于2倍的（90-触摸点跟底边x轴的夹角（或者跟Y轴夹角？））；
    /// 沿着触摸点、两条贝塞尔终点、顶点 这个区域进行一次裁剪

    var canvas = context.canvas;

    var angle =
        2 * (pi / 2 - atan2(mCornerY - mTouch.dy, mCornerX - mTouch.dx));
    canvas.save();

    canvas.clipPath(mTopBackAreaPagePath);
    canvas.drawColor(Colors.red, BlendMode.color);

    canvas.save();

    Path tempPath = Path()..moveTo(mTouch.dx, mTouch.dy);
    tempPath.lineTo(mBezierControl1.dx, mBezierControl1.dy);
    tempPath.lineTo(mBezierControl2.dx, mBezierControl2.dy);
    tempPath.close();

    Path limitPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, child.size.height)
      ..lineTo(child.size.width, child.size.height)
      ..lineTo(child.size.width, 0)
      ..close();

    if (!limitPath.getBounds().hasNaN && !tempPath.getBounds().hasNaN) {
      try {
        tempPath = Path.combine(PathOperation.intersect, limitPath, tempPath);
      } on StateError {
        print('path combine failed');
      }
    }

    canvas.clipPath(tempPath);

    if (mCornerY == 0) {
      canvas.translate(child.size.width, 0);
      canvas.scale(-1, 1);

      canvas.translate(-mTouch.dx, mTouch.dy);
      canvas.translate(mCornerX, mCornerY);
      canvas.rotate(angle - pi);
      canvas.translate(-mCornerX, -mCornerY);
    } else {
      canvas.translate(0, child.size.height);
      canvas.scale(1, -1);

      canvas.translate(mTouch.dx - child.size.width, -mTouch.dy);
      canvas.translate(child.size.width, child.size.height);
      canvas..rotate(angle);
      canvas.translate(-child.size.width, -child.size.height);
    }

    context.paintChild(child, Offset.zero);

    canvas..restore();

    canvas.restore();
  }

  /// 绘制背面部分和其阴影
  void drawShadowOfBackSide(PaintingContext context, RenderBox child) {
    /// 在两条贝塞尔曲线顶点连线的两边画个过渡方框即可

    var shadowLongerSideLength =
        getDistanceOfTwoPoint(mBezierStart2, mBezierStart1);
    var shadowShorterSideLength =
        getDistanceOfTwoPoint(mTouch, Offset(mCornerX, mCornerY)) / 4;

    var angle = (pi / 2) -
        atan2(mBezierStart1.dx - mBezierStart2.dx,
                mBezierStart1.dy - mBezierStart2.dy)
            .abs();

    print('angle is $angle');

    var canvas = context.canvas;

    canvas.save();

    canvas.clipPath(mBottomPagePath);

    canvas.translate(mBezierStart1.dx, mBezierStart1.dy);
    canvas.rotate(-angle);
    canvas.translate(-mBezierStart1.dx, -mBezierStart1.dy);

    canvas.drawRect(
        Rect.fromLTRB(
            mBezierStart1.dx,
            mBezierStart1.dy - (mCornerY == 0 ? shadowShorterSideLength : 0),
            mBezierStart1.dx + shadowLongerSideLength,
            mBezierStart1.dy + (mCornerY == 0 ? 0 : shadowShorterSideLength)),
        shadowPainter);

    canvas.restore();
  }

  void calPath() {
    mBottomPagePath.reset();
    mBottomPagePath.moveTo(mCornerX, mCornerY);
    mBottomPagePath.lineTo(mBezierStart1.dx, mBezierStart1.dy);
    mBottomPagePath.quadraticBezierTo(
        mBezierControl1.dx, mBezierControl1.dy, mBezierEnd1.dx, mBezierEnd1.dy);
    mBottomPagePath.lineTo(mTouch.dx, mTouch.dy);
    mBottomPagePath.lineTo(mBezierEnd2.dx, mBezierEnd2.dy);
    mBottomPagePath.quadraticBezierTo(mBezierControl2.dx, mBezierControl2.dy,
        mBezierStart2.dx, mBezierStart2.dy);
    mBottomPagePath.close();

    mTopBackAreaPagePath.reset();
    mTopBackAreaPagePath.moveTo(mTouch.dx, mTouch.dy);
    mTopBackAreaPagePath.lineTo(mBezierVertex1.dx, mBezierVertex1.dy);
    mTopBackAreaPagePath.lineTo(mBezierVertex2.dx, mBezierVertex2.dy);
    mTopBackAreaPagePath.close();

    if (mTopBackAreaPagePath.getBounds().hasNaN ||
        mTopBackAreaPagePath.getBounds().isEmpty) {
      return;
    }

    try {
      mTopBackAreaPagePath = Path.combine(
          PathOperation.intersect, mTopBackAreaPagePath, mBottomPagePath);
    } on StateError {
      print(
          'path combine failed , current backpackArea is ${mTopBackAreaPagePath.getBounds()} , current bottomArea is ${mBottomPagePath.getBounds()}');
    }
  }
}
