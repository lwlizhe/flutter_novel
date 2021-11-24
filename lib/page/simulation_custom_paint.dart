import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';

class SimulationCustomPaint extends CustomPaint {
  /// Creates a widget that delegates its painting.
  const SimulationCustomPaint({
    Key? key,
    CustomPainter? painter,
    CustomPainter? foregroundPainter,
    Size size = Size.zero,
    bool isComplex = false,
    bool willChange = false,
    Widget? child,
    this.gestureDataNotify,
  }) : super(
          key: key,
          child: child,
          painter: painter,
          foregroundPainter: foregroundPainter,
          size: size,
          isComplex: isComplex,
          willChange: willChange,
        );

  final PowerListGestureDataNotify? gestureDataNotify;

  @override
  SimulationRenderCustomPaint createRenderObject(BuildContext context) {
    return SimulationRenderCustomPaint(
      painter: painter,
      foregroundPainter: foregroundPainter,
      preferredSize: size,
      isComplex: isComplex,
      willChange: willChange,
      gestureDataNotify: gestureDataNotify,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant SimulationRenderCustomPaint renderObject) {
    renderObject
      ..painter = painter
      ..foregroundPainter = foregroundPainter
      ..preferredSize = size
      ..isComplex = isComplex
      ..willChange = willChange
      ..gestureDataNotify = gestureDataNotify;
  }
}

class SimulationRenderCustomPaint extends RenderCustomPaint {
  SimulationRenderCustomPaint({
    CustomPainter? painter,
    CustomPainter? foregroundPainter,
    Size preferredSize = Size.zero,
    bool isComplex = false,
    bool willChange = false,
    RenderBox? child,
    PowerListGestureDataNotify? gestureDataNotify,
  })  : _gestureDataNotify = gestureDataNotify,
        super(
            painter: painter,
            foregroundPainter: foregroundPainter,
            preferredSize: preferredSize,
            isComplex: isComplex,
            willChange: willChange,
            child: child);

  _SimulationTurnPagePainterHelper helper = _SimulationTurnPagePainterHelper();
  Paint circlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.green;
  Paint maskPaint = Paint()..blendMode = BlendMode.clear;

  PowerListGestureDataNotify? get gestureDataNotify => _gestureDataNotify;
  PowerListGestureDataNotify? _gestureDataNotify;

  set gestureDataNotify(PowerListGestureDataNotify? value) {
    if (_gestureDataNotify == value) return;
    final PowerListGestureDataNotify? oldNotify = _gestureDataNotify;
    _gestureDataNotify = value;
    _didUpdateGestureDataNotify(_gestureDataNotify, oldNotify);
  }

  void _didUpdateGestureDataNotify(PowerListGestureDataNotify? newNotify,
      PowerListGestureDataNotify? oldNotify) {
    // Check if we need to repaint.
    if (newNotify == null) {
      assert(oldNotify != null); // We should be called only for changes.
      markNeedsPaint();
    } else if (newNotify == null ||
        newNotify.runtimeType != oldNotify.runtimeType) {
      markNeedsPaint();
    }
    if (attached) {
      oldNotify?.removeListener(markNeedsPaint);
      newNotify?.addListener(markNeedsPaint);
    }

    // Check if we need to rebuild semantics.
    if (newNotify == null) {
      assert(oldNotify != null); // We should be called only for changes.
      if (attached) markNeedsSemanticsUpdate();
    } else if (oldNotify == null ||
        newNotify.runtimeType != oldNotify.runtimeType) {
      markNeedsSemanticsUpdate();
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _gestureDataNotify?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    super.detach();
    _gestureDataNotify?.removeListener(markNeedsPaint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(Offset.zero & size, Paint());

    context.paintChild(child!, offset);

    helper.currentSize = size;

    if (_gestureDataNotify != null &&
        _gestureDataNotify?.pointerEvent != null) {
      if (_gestureDataNotify?.pointerEvent is PointerDownEvent) {
        helper.calcCornerXY(_gestureDataNotify!.pointerEvent!.localPosition.dx,
            _gestureDataNotify!.pointerEvent!.localPosition.dy);
      }
      helper.mTouch = _gestureDataNotify!.pointerEvent!.localPosition;
    } else {
      helper.mTouch = Offset(size.width / 2, size.height / 2);
    }

    helper.calBezierPoint();
    helper.drawBottomPageCanvas(context.canvas);

    // context.canvas
    //     .drawCircle(Offset(size.width / 2, size.height / 2), 50.0, maskPaint);

    context.canvas.restore();
  }
}

class _SimulationTurnPagePainterHelper {
  Offset? mTouch = Offset(0, 0);
  Size currentSize = Size(0, 0);

  Offset mBezierStart1 = new Offset(0, 0); // 贝塞尔曲线起始点
  Offset mBezierControl1 = new Offset(0, 0); // 贝塞尔曲线控制点
  Offset mBezierVertex1 = new Offset(0, 0); // 贝塞尔曲线顶点
  Offset mBezierEnd1 = new Offset(0, 0); // 贝塞尔曲线结束点

  Offset mBezierStart2 = new Offset(0, 0); // 另一条贝塞尔曲线
  Offset mBezierControl2 = new Offset(0, 0);
  Offset mBezierVertex2 = new Offset(0, 0);
  Offset mBezierEnd2 = new Offset(0, 0);

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
  void calcCornerXY(double x, double y) {
    if (x <= currentSize.width / 2) {
      mCornerX = 0;
    } else {
      mCornerX = currentSize.width;
    }

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

  /// 画翻起来的底下那页 ///
  void drawBottomPageCanvas(Canvas canvas) {
    mBottomPagePath.reset();
    mBottomPagePath.moveTo(mCornerX, mCornerY);
    mBottomPagePath.lineTo(mBezierStart1.dx, mBezierStart1.dy);
    mBottomPagePath.quadraticBezierTo(
        mBezierControl1.dx, mBezierControl1.dy, mBezierEnd1.dx, mBezierEnd1.dy);
    mBottomPagePath.lineTo(mBezierEnd2.dx, mBezierEnd2.dy);
    mBottomPagePath.quadraticBezierTo(mBezierControl2.dx, mBezierControl2.dy,
        mBezierStart2.dx, mBezierStart2.dy);
    mBottomPagePath.close();

    Path extraRegion = Path();

    extraRegion.reset();
    extraRegion.moveTo(mTouch!.dx, mTouch!.dy);
    extraRegion.lineTo(mBezierVertex1.dx, mBezierVertex1.dy);
    extraRegion.lineTo(mBezierVertex2.dx, mBezierVertex2.dy);
    extraRegion.close();

    mBottomPagePath =
        Path.combine(PathOperation.difference, mBottomPagePath, extraRegion);

//    /// 使用fillType来反选填充区域 ///
//    mBottomPagePath = mTopPagePath
//      ..addRect(Offset.zero & currentSize)
//      ..addPath(mTopBackAreaPagePath, Offset(0, 0))
//      ..fillType = PathFillType.evenOdd;

    /// 去掉PATH圈在屏幕外的区域，减少GPU使用
    mBottomPagePath = Path.combine(
        PathOperation.intersect,
        Path()
          ..moveTo(0, 0)
          ..lineTo(currentSize.width, 0)
          ..lineTo(currentSize.width, currentSize.height)
          ..lineTo(0, currentSize.height)
          ..close(),
        mBottomPagePath);

    canvas.save();
    canvas.clipPath(mBottomPagePath, doAntiAlias: false);
//    canvas.drawPaint(Paint()..color = Color(0xfffff2cc));
//    canvas.drawImageRect(
//        isTurnToNext?readerViewModel.getNextPage().pageImage:readerViewModel.getPrePage().pageImage,
//        Offset.zero & currentSize,
//        Offset.zero & currentSize,
//        Paint()
//          ..isAntiAlias = true
//          ..blendMode = BlendMode.srcATop);
    canvas.drawColor(Colors.white, BlendMode.clear);
//

    canvas.restore();
  }

  /// 画顶部页的阴影 ///
  void drawTopPageShadow(Canvas canvas) {
    Path shadowPath = Path();

    int dx = mCornerX == 0 ? 5 : -5;
    int dy = mCornerY == 0 ? 5 : -5;

    shadowPath = Path.combine(
        PathOperation.intersect,
        Path()
          ..moveTo(0, 0)
          ..lineTo(currentSize.width, 0)
          ..lineTo(currentSize.width, currentSize.height)
          ..lineTo(0, currentSize.height)
          ..close(),
        Path()
          ..moveTo(mTouch!.dx + dx, mTouch!.dy + dy)
          ..lineTo(mBezierControl2.dx + dx, mBezierControl2.dy + dy)
          ..lineTo(mBezierControl1.dx + dx, mBezierControl1.dy + dy)
          ..close());

    canvas.drawShadow(shadowPath, Colors.black, 5, true);
  }
}