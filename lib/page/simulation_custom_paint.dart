import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/layout/manager/simulation/helper/power_list_simulation_helper.dart';
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
    this.position,
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
  final ScrollPosition? position;

  @override
  SimulationRenderCustomPaint createRenderObject(BuildContext context) {
    return SimulationRenderCustomPaint(
      painter: painter,
      foregroundPainter: foregroundPainter,
      preferredSize: size,
      isComplex: isComplex,
      willChange: willChange,
      gestureDataNotify: gestureDataNotify,
      position: position,
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
      ..position = position
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
    ScrollPosition? position,
  })  : _gestureDataNotify = gestureDataNotify,
        _position = position,
        super(
            painter: painter,
            foregroundPainter: foregroundPainter,
            preferredSize: preferredSize,
            isComplex: isComplex,
            willChange: willChange,
            child: child);

  SimulationTurnPagePainterHelper helper = SimulationTurnPagePainterHelper();
  Paint circlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.green;
  Paint maskPaint = Paint()..blendMode = BlendMode.clear;

  PowerListGestureDataNotify? get gestureDataNotify => _gestureDataNotify;
  PowerListGestureDataNotify? _gestureDataNotify;

  ScrollPosition? get position => _position;
  ScrollPosition? _position;

  Offset lastTouchPointOffset = Offset.zero;

  bool isNeedCalCorner = true;

  set gestureDataNotify(PowerListGestureDataNotify? value) {
    if (_gestureDataNotify == value) return;
    final PowerListGestureDataNotify? oldNotify = _gestureDataNotify;
    _gestureDataNotify = value;
    _didUpdateGestureDataNotify(_gestureDataNotify, oldNotify);
  }

  set position(ScrollPosition? value) {
    if (_position == value) return;
    final ScrollPosition? oldNotify = _position;
    _position = value;
    _didUpdateScrollPosition(_position, oldNotify);
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

  void _didUpdateScrollPosition(
      ScrollPosition? newNotify, ScrollPosition? oldNotify) {
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
    _position?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    super.detach();
    _gestureDataNotify?.removeListener(markNeedsPaint);
    _position?.removeListener(markNeedsPaint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.saveLayer(Offset.zero & size, Paint());

    context.paintChild(child!, offset);

    helper.currentSize = size;

    if (_gestureDataNotify != null &&
        _gestureDataNotify?.pointerEvent != null &&
        _position != null) {
      Offset touchPoint = Offset(
          (_position?.pixels ?? 0) == 0 ? 0 : size.width - _position!.pixels,
          _gestureDataNotify!.pointerEvent!.localPosition.dy);

      if (_gestureDataNotify?.pointerEvent is PointerMoveEvent) {
        if (isNeedCalCorner) {
          helper.calcCornerXY(
              _gestureDataNotify!.pointerEvent!.delta.dx, touchPoint.dy);
          isNeedCalCorner = false;
        }
      }
      if (_gestureDataNotify?.pointerEvent is PointerUpEvent) {
        if (!isNeedCalCorner) {
          isNeedCalCorner = true;
        }
      }

      if (_gestureDataNotify?.pointerEvent is PointerDownEvent ||
          _gestureDataNotify?.pointerEvent is PointerMoveEvent) {
        lastTouchPointOffset =
            _gestureDataNotify?.pointerEvent?.localPosition ?? Offset.zero;
      }

      if (_gestureDataNotify?.pointerEvent is PointerUpEvent ||
          _gestureDataNotify?.pointerEvent is PointerCancelEvent) {}

      helper.mTouch = touchPoint;
    }

    helper.calBezierPoint();
    helper.clearBottomCanvasArea(context.canvas);

    context.canvas.restore();
  }

  double calPercentDy() {
    return 0;
  }
}
