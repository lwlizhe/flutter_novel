import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';

class PowerListSimulationScrollDragController extends ScrollDragController {
  PowerListSimulationScrollDragController({
    required PowerListScrollPositionWithSingleContext delegate,
    required DragStartDetails details,
    VoidCallback? onDragCanceled,
    double? carriedVelocity,
    double? motionStartDistanceThreshold,
    required TickerProvider vsync,
  })  : position = delegate,
        vsync = vsync,
        super(
            delegate: delegate,
            details: details,
            onDragCanceled: onDragCanceled,
            carriedVelocity: carriedVelocity,
            motionStartDistanceThreshold: motionStartDistanceThreshold);

  final PowerListScrollPositionWithSingleContext position;
  final TickerProvider vsync;

  AnimationController? _controller;

  double targetDx = 0;

  @override
  void update(DragUpdateDetails details) {
    targetDx = calTargetDx(details);

    if ((details.primaryDelta ?? 0) <= 0) {
      super.update(details);
    } else {
      if (position.pixels != targetDx) {
        if (_controller == null) {
          startAnimation(details, targetDx);
          return;
        }
      }
      super.update(details);
    }
  }

  @override
  void end(DragEndDetails details) {
    clearAnimation();
    super.end(details);
  }

  @override
  void cancel() {
    clearAnimation();
    super.cancel();
  }

  @override
  void dispose() {
    clearAnimation();
    super.dispose();
  }

  void clearAnimation() {
    _controller?.dispose();
    _controller = null;
  }

  void startAnimation(DragUpdateDetails details, double to) {
    _controller = AnimationController.unbounded(
      value: position.pixels,
      debugLabel:
          objectRuntimeType(this, 'PowerListSimulationScrollDragController'),
      vsync: vsync,
    )
      ..addListener(_tick)
      ..animateTo(
              position.pixels >= to
                  ? position.pixels - position.viewportDimension
                  : position.pixels + position.viewportDimension,
              duration: Duration(milliseconds: 200),
              curve: Curves.linear)
          .whenComplete(_end);
  }

  double calTargetDx(DragUpdateDetails details) {
    var currentPage =
        getPageFromPixels(position.pixels, position.viewportDimension);

    if (currentPage % currentPage.toInt() == 0) {
      currentPage = currentPage - 1;
    }

    var page = max(0, currentPage).toInt();

    var dx = page * position.viewportDimension +
        (position.viewportDimension - (details.globalPosition.dx));

    return dx;
  }

  double getPageFromPixels(double pixels, double viewportDimension) {
    final double actual = max(0.0, pixels) / max(1.0, viewportDimension * 1);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  void _tick() {
    var pixel = _controller?.value ?? 0;

    if ((_controller?.velocity ?? 0) <= 0
        ? pixel <= targetDx
        : pixel >= targetDx) {
      print(
          'tick stop , delta is ${_controller?.velocity} , pixel is $pixel , targetDx is $targetDx');
      _controller?.stop();
      pixel = targetDx;
    }
    if (delegate.setPixels(pixel) != 0.0) {
      // delegate.goIdle();
    }
  }

  void _end() {
    // delegate.goBallistic(0.0);
  }

  bool isRunningAnimation() {
    return _controller?.isAnimating ?? false;
  }
}

class PowerListSimulationDragScrollActivity extends ScrollActivity {
  /// Creates an activity for when the user drags their finger across the
  /// screen.
  PowerListSimulationDragScrollActivity(
    PowerListScrollPositionWithSingleContext delegate,
    PowerListSimulationScrollDragController controller,
  )   : _controller = controller,
        super(delegate);

  PowerListSimulationScrollDragController? _controller;

  @override
  void dispatchScrollStartNotification(
      ScrollMetrics metrics, BuildContext? context) {
    final dynamic lastDetails = _controller!.lastDetails;
    assert(lastDetails is DragStartDetails);
    ScrollStartNotification(
            metrics: metrics,
            context: context,
            dragDetails: lastDetails as DragStartDetails)
        .dispatch(context);
  }

  @override
  void dispatchScrollUpdateNotification(
      ScrollMetrics metrics, BuildContext context, double scrollDelta) {
    if (_controller!.isRunningAnimation()) {
      return;
    }

    final dynamic lastDetails = _controller!.lastDetails;
    assert(lastDetails is DragUpdateDetails);
    ScrollUpdateNotification(
            metrics: metrics,
            context: context,
            scrollDelta: scrollDelta,
            dragDetails: lastDetails as DragUpdateDetails)
        .dispatch(context);
  }

  @override
  void dispatchOverscrollNotification(
      ScrollMetrics metrics, BuildContext context, double overscroll) {
    if (_controller!.isRunningAnimation()) {
      return;
    }

    final dynamic lastDetails = _controller!.lastDetails;
    assert(lastDetails is DragUpdateDetails);
    OverscrollNotification(
            metrics: metrics,
            context: context,
            overscroll: overscroll,
            dragDetails: lastDetails as DragUpdateDetails)
        .dispatch(context);
  }

  @override
  void dispatchScrollEndNotification(
      ScrollMetrics metrics, BuildContext context) {
    // We might not have DragEndDetails yet if we're being called from beginActivity.
    final dynamic lastDetails = _controller!.lastDetails;
    ScrollEndNotification(
      metrics: metrics,
      context: context,
      dragDetails: lastDetails is DragEndDetails ? lastDetails : null,
    ).dispatch(context);
  }

  @override
  bool get shouldIgnorePointer => true;

  @override
  bool get isScrolling => true;

  // DragScrollActivity is not independently changing velocity yet
  // until the drag is ended.
  @override
  double get velocity => 0.0;

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($_controller)';
  }
}

class PowerListBallisticScrollActivity extends ScrollActivity {
  /// Creates an activity that animates a scroll view based on a [simulation].
  ///
  /// The [delegate], [simulation], and [vsync] arguments must not be null.
  PowerListBallisticScrollActivity(
    ScrollActivityDelegate delegate,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(delegate) {
    _controller = AnimationController.unbounded(
      debugLabel: kDebugMode
          ? objectRuntimeType(this, 'BallisticScrollActivity')
          : null,
      vsync: vsync,
    )
      ..addListener(_tick)
      ..animateWith(simulation)
          .whenComplete(_end); // won't trigger if we dispose _controller first
  }

  late AnimationController _controller;

  @override
  void resetActivity() {
    delegate.goBallistic(velocity);
  }

  @override
  void applyNewDimensions() {
    delegate.goBallistic(velocity);
  }

  void _tick() {
    if (!applyMoveTo(_controller.value)) delegate.goIdle();
  }

  /// Move the position to the given location.
  ///
  /// If the new position was fully applied, returns true. If there was any
  /// overflow, returns false.
  ///
  /// The default implementation calls [ScrollActivityDelegate.setPixels]
  /// and returns true if the overflow was zero.
  @protected
  bool applyMoveTo(double value) {
    return delegate.setPixels(value) == 0.0;
  }

  void _end() {
    delegate.goBallistic(0.0);
  }

  @override
  void dispatchOverscrollNotification(
      ScrollMetrics metrics, BuildContext context, double overscroll) {
    OverscrollNotification(
            metrics: metrics,
            context: context,
            overscroll: overscroll,
            velocity: velocity)
        .dispatch(context);
  }

  @override
  bool get shouldIgnorePointer => true;

  @override
  bool get isScrolling => true;

  @override
  double get velocity => _controller.velocity;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($_controller)';
  }

  bool isAnimationRunning() {
    return _controller.isAnimating;
  }
}
