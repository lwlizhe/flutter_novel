import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';

abstract class PowerListScrollActivity extends ScrollActivity {
  PowerListScrollActivity(ScrollActivityDelegate delegate) : super(delegate);

  bool get shouldInterceptDrag;
}

class DrivenScrollDynamicActivity extends PowerListScrollActivity {
  DrivenScrollDynamicActivity(
    PowerListScrollPositionWithSingleContext delegate, {
    required double from,
    required double to,
    required Duration duration,
    required Curve curve,
    required TickerProvider vsync,
  })  : assert(from != null),
        assert(to != null),
        assert(duration != null),
        assert(duration > Duration.zero),
        assert(curve != null),
        super(delegate) {
    _completer = Completer<void>();
    target = to;
    _controller = AnimationController.unbounded(
      value: from,
      debugLabel: objectRuntimeType(this, 'DrivenScrollActivity'),
      vsync: vsync,
    )
      ..addListener(_tick)
      ..animateTo(to - 500, duration: duration, curve: curve)
          .whenComplete(_end); // won't trigger if we dispose _controller first
  }

  late final Completer<void> _completer;
  late final AnimationController _controller;

  double target = 0;

  /// A [Future] that completes when the activity stops.
  ///
  /// For example, this [Future] will complete if the animation reaches the end
  /// or if the user interacts with the scroll view in way that causes the
  /// animation to stop before it reaches the end.
  Future<void> get done => _completer.future;

  void _tick() {
    if (_controller.value <= target) {
      _controller.stop(canceled: false);

      if (!_completer.isCompleted) {
        _completer.complete();
      }
      if (delegate.setPixels(target) != 0.0) {
        if (!(delegate as PowerListScrollPositionWithSingleContext)
            .isInDrag()) {
          delegate.goIdle();
        }
      }
    }
    if (delegate.setPixels(_controller.value) != 0.0) {
      if (!(delegate as PowerListScrollPositionWithSingleContext).isInDrag()) {
        delegate.goIdle();
      }
    }
  }

  void _end() {
    if (!(delegate as PowerListScrollPositionWithSingleContext).isInDrag()) {
      delegate.goBallistic(velocity);
    }
  }

  void updateEnd(double to) {
    target = to;
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
    if (!_completer.isCompleted) {
      _completer.complete();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($_controller)';
  }

  @override
  bool get shouldInterceptDrag => false;
}
