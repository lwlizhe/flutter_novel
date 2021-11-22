import 'dart:math';

import 'package:flutter/material.dart';

class SimulationForegroundTurnPagePainter extends CustomPainter {
  Paint painter = Paint()..color = Colors.green;

  _SimulationTurnPagePainterHelper helper = _SimulationTurnPagePainterHelper();

  Offset touchPoint = Offset.zero;

  void setTouchPoint(Offset point) {
    touchPoint = point;
  }

  Paint circlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;
  Paint maskPaint = Paint()..blendMode = BlendMode.clear;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.saveLayer(Offset.zero & size, Paint());
    helper.currentSize = size;
    helper.mTouch = Offset(size.width / 2, size.height / 2);
    helper.calBezierPoint();
    helper.drawTopPageCanvas(canvas);
    canvas.restore();

    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), 30, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SimulationTurnPagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
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

    print(' ---------------------------------------------------------------- ');
    print(' cal bezier ' +
        'mBezierStart1 : $mBezierStart1 , mBezierControl1 : $mBezierControl1 , mBezierVertex1 : $mBezierVertex1 , mBezierEnd1 : $mBezierEnd1 , mBezierStart2 : $mBezierStart2 , mBezierControl2 : $mBezierControl2 , mBezierVertex2 : $mBezierVertex2 , mBezierEnd2 : $mBezierEnd2');
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

  /// 画在最顶上的那页 ///
  void drawTopPageCanvas(Canvas canvas) {
    mTopPagePath.reset();

    mTopPagePath.moveTo(mCornerX == 0 ? currentSize.width : 0, mCornerY);
    mTopPagePath.lineTo(mBezierStart1.dx, mBezierStart1.dy);
    mTopPagePath.quadraticBezierTo(
        mBezierControl1.dx, mBezierControl1.dy, mBezierEnd1.dx, mBezierEnd1.dy);
    mTopPagePath.lineTo(mTouch!.dx, mTouch!.dy);
    mTopPagePath.lineTo(mBezierEnd2.dx, mBezierEnd2.dy);
    mTopPagePath.quadraticBezierTo(mBezierControl2.dx, mBezierControl2.dy,
        mBezierStart2.dx, mBezierStart2.dy);
    mTopPagePath.lineTo(mCornerX, mCornerY == 0 ? currentSize.height : 0);
    mTopPagePath.lineTo(mCornerX == 0 ? currentSize.width : 0,
        mCornerY == 0 ? currentSize.height : 0);
    mTopPagePath.close();

    // /// 去掉PATH圈在屏幕外的区域，减少GPU使用
    // mTopPagePath = Path.combine(
    //     PathOperation.intersect,
    //     Path()
    //       ..moveTo(0, 0)
    //       ..lineTo(currentSize.width, 0)
    //       ..lineTo(currentSize.width, currentSize.height)
    //       ..lineTo(0, currentSize.height)
    //       ..close(),
    //     mTopPagePath);

    canvas.clipPath(mTopPagePath);
    canvas.drawColor(Colors.white.withAlpha(50), BlendMode.clear);

    // drawTopPageShadow(canvas);
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
