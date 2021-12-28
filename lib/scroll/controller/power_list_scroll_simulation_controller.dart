import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/activity/power_list_scroll_activity.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';

class PowerListScrollSimulationController extends PowerListScrollController {
  PowerListScrollSimulationController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    bool isLoop = false,
    String? debugLabel,
  }) : super(
            initialScrollOffset: initialScrollOffset,
            keepScrollOffset: keepScrollOffset,
            isLoop: isLoop,
            debugLabel: debugLabel);

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return PowerListScrollSimulationPositionWithSingleContext(
      physics: physics,
      context: context,
      isLoop: isLoop,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

class PowerListScrollSimulationPositionWithSingleContext
    extends PowerListScrollPositionWithSingleContext {
  /// Create a [ScrollPosition] object that manages its behavior using
  /// [ScrollActivity] objects.
  ///
  /// The `initialPixels` argument can be null, but in that case it is
  /// imperative that the value be set, using [correctPixels], as soon as
  /// [applyNewDimensions] is invoked, before calling the inherited
  /// implementation of that method.
  ///
  /// If [keepScrollOffset] is true (the default), the current scroll offset is
  /// saved with [PageStorage] and restored it if this scroll position's scrollable
  /// is recreated.
  PowerListScrollSimulationPositionWithSingleContext({
    required ScrollPhysics physics,
    required ScrollContext context,
    double? initialPixels = 0.0,
    bool isLoop = false,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
  }) : super(
          physics: physics,
          context: context,
          keepScrollOffset: keepScrollOffset,
          isLoop: isLoop,
          oldPosition: oldPosition,
          debugLabel: debugLabel,
        ) {
    // If oldPosition is not null, the superclass will first call absorb(),
    // which may set _pixels and _activity.
    if (!hasPixels && initialPixels != null) correctPixels(initialPixels);
    if (activity == null) goIdle();
    assert(activity != null);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    final PowerListSimulationScrollDragController drag =
        PowerListSimulationScrollDragController(
      delegate: this,
      details: details,
      onDragCanceled: dragCancelCallback,
      carriedVelocity: physics.carriedMomentum(heldPreviousVelocity),
      motionStartDistanceThreshold: physics.dragStartDistanceMotionThreshold,
      vsync: context.vsync,
    );
    beginActivity(PowerListSimulationDragScrollActivity(this, drag));
    assert(currentDrag == null);
    currentDrag = drag;
    return drag;
  }

  @override
  void goBallistic(double velocity) {
    assert(hasPixels);
    final Simulation? simulation =
        physics.createBallisticSimulation(this, velocity);
    if (simulation != null) {
      beginActivity(
          PowerListBallisticScrollActivity(this, simulation, context.vsync));
    } else {
      goIdle();
    }
  }
}
