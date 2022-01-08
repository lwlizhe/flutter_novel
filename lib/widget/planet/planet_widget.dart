import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:test_project/widget/planet/entity/planet_tag_info.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class PlanetWidget extends StatefulWidget {
  const PlanetWidget({Key? key, required this.children}) : super(key: key);

  @override
  _PlanetWidgetState createState() => _PlanetWidgetState();

  final List<Widget> children;
}

class _PlanetWidgetState extends State<PlanetWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController reloadAnimationController;

  double preAngle = 0;
  double _radius = 0;

  List<PlanetTagInfo>? childTagList = [];

  Vector3 currentOperateVector = Vector3(1.0, 0.0, 0.0);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(lowerBound: 0, upperBound: pi * 2, vsync: this);
    reloadAnimationController = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        duration: Duration(milliseconds: 300),
        vsync: this);

    animationController.addListener(() {
      setState(() {
        calTagInfo(animationController.value - preAngle);
      });
    });
    reloadAnimationController.addListener(() {
      setState(() {});
    });

    childTagList = widget.children
        .map((e) => PlanetTagInfo(child: e, planetTagPos: Vector3.zero()))
        .toList();

    currentOperateVector = updateOperateVector(Offset(-1.0, 1.0));

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initTagInfo();
      reloadAnimationController.forward().then((value) => _reStartAnimation());
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _radius = min(constraints.maxWidth, constraints.maxHeight) / 2.0;

        final Map<Type, GestureRecognizerFactory> gestures =
            <Type, GestureRecognizerFactory>{};
        gestures[PanGestureRecognizer] =
            GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
          () => PanGestureRecognizer(debugOwner: this),
          (PanGestureRecognizer instance) {
            instance
              ..onDown = (detail) {
                if (animationController.isAnimating) {
                  _stopAnimation();
                }
              }
              ..onStart = (detail) {
                if (animationController.isAnimating) {
                  _stopAnimation();
                }
              }
              ..onUpdate = (detail) {
                double distance = sqrt(detail.delta.dx * detail.delta.dx +
                    detail.delta.dy * detail.delta.dy);
                setState(() {
                  currentOperateVector = updateOperateVector(detail.delta);
                  calTagInfo(distance / _radius);
                });
              }
              ..onEnd = (detail) {
                startFlingAnimation(detail);
              }
              ..onCancel = () {
                _reStartAnimation();
              }
              ..dragStartBehavior = DragStartBehavior.start
              ..gestureSettings =

                  /// 为了能竞争过 HorizontalDragGestureRecognizer ，不得不使用一些下作手段；
                  /// 比如说卷起来，判断阈值比 HorizontalDragGestureRecognizer 的阈值小；
                  /// PS ： PanGestureRecognizer 的判断阈值是 touchSlop * 2；
                  const DeviceGestureSettings(touchSlop: kTouchSlop / 4);
          },
        );

        gestures[TapGestureRecognizer] =
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(debugOwner: this),
          (TapGestureRecognizer instance) {
            instance
              ..onTapDown = (detail) {
                _stopAnimation();
              }
              ..onTapUp = (detail) {
                _reStartAnimation();
              }
              ..onTapCancel = () {
                _reStartAnimation();
              };
          },
        );

        return RawGestureDetector(
          gestures: gestures,
          behavior: HitTestBehavior.translucent,
          excludeFromSemantics: false,
          child: Container(
            width: _radius * 2,
            height: _radius * 2,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                childTagList?.sort((item1, item2) =>
                    item1.planetTagPos.z.compareTo(item2.planetTagPos.z));
                return Stack(
                  alignment: Alignment.center,
                  children: childTagList
                          ?.map((e) => Transform(
                                transform: calTransformByTagInfo(
                                    e, animationController.value),
                                child: Opacity(
                                  opacity: e.opacity,
                                  child: RepaintBoundary(
                                    child: e.child,
                                  ),
                                ),
                              ))
                          .toList() ??
                      [],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _stopAnimation() {
    animationController.stop();
  }

  void _reStartAnimation() {
    animationController.value = preAngle;
    animationController.repeat(
        min: 0, max: pi * 2, period: Duration(seconds: 20));
  }

  void startFlingAnimation(DragEndDetails detail) {
    /// 计算手势要滑动多少距离
    var velocityPerDis = sqrt(pow(detail.velocity.pixelsPerSecond.dx, 2) +
        pow(detail.velocity.pixelsPerSecond.dy, 2));

    if (velocityPerDis < 5) {
      _reStartAnimation();
      return;
    }

    /// 距离处以周长就是变化的角度,最大一周
    var angle = min(
        2 * pi,
        animationController.value +
            velocityPerDis / (2 * pi * _radius) * (2 * pi));

    animationController
        .animateWith(SpringSimulation(
            SpringDescription.withDampingRatio(
              mass: 1.0,
              stiffness: 500.0,
            ),
            animationController.value,
            angle,
            1)
          ..tolerance = Tolerance(
            velocity: double.infinity,
            distance: 0.01,
          ))
        .then((value) => _reStartAnimation());
  }

  @override
  void dispose() {
    animationController.dispose();
    reloadAnimationController.dispose();
    super.dispose();
  }

  void initTagInfo() {
    final itemCount = childTagList?.length ?? 0;

    for (var index = 1; index < itemCount + 1; index++) {
      final phi = (acos(-1.0 + (2.0 * index - 1.0) / itemCount));
      final theta = sqrt(itemCount * pi) * phi;

      final x = _radius * cos(theta) * sin(phi);
      final y = _radius * sin(theta) * sin(phi);
      final z = _radius * cos(phi);

      var childItem = childTagList?[index - 1];
      childItem?.planetTagPos = Vector3(x, y, z);
      childItem?.currentAngle = phi;
      childItem?.radius = _radius;
    }
  }

  void calTagInfo(double dAngle) {
    var currentAngle = preAngle + dAngle;

    final itemCount = childTagList?.length ?? 0;

    for (var index = 1; index < itemCount + 1; index++) {
      var childItem = childTagList![index - 1];

      var point = childItem.planetTagPos;

      double x = cos(dAngle) * point.x +
          (1 - cos(dAngle)) *
              (currentOperateVector.x * point.x +
                  currentOperateVector.y * point.y) *
              currentOperateVector.x +
          sin(dAngle) * (currentOperateVector.y * point.z);

      double y = cos(dAngle) * point.y +
          (1 - cos(dAngle)) *
              (currentOperateVector.x * point.x +
                  currentOperateVector.y * point.y) *
              currentOperateVector.y -
          sin(dAngle) * (currentOperateVector.x * point.z);

      double z = cos(dAngle) * point.z +
          sin(dAngle) *
              (currentOperateVector.x * point.y -
                  currentOperateVector.y * point.x);

      childItem.planetTagPos = Vector3(x, y, z);
      childItem.currentAngle = currentAngle;
    }

    if (animationController.isAnimating) {
      preAngle = currentAngle;
    }
  }

  Vector3 updateOperateVector(Offset operateOffset) {
    double x = -operateOffset.dy;
    double y = operateOffset.dx;
    double module = sqrt(x * x + y * y);
    return Vector3(x / module, y / module, 0.0);
  }

  Matrix4 calTransformByTagInfo(PlanetTagInfo tagInfo, double currentAngle) {
    var result = Matrix4.identity();
    result.translate(
        tagInfo.planetTagPos.x * reloadAnimationController.value,
        tagInfo.planetTagPos.y * reloadAnimationController.value,
        tagInfo.planetTagPos.z * reloadAnimationController.value);
    result.scale(tagInfo.scale);
    return result;
  }
}
