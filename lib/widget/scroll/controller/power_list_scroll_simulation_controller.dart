import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_project/widget/scroll/activity/power_list_scroll_activity.dart';
import 'package:test_project/widget/scroll/controller/power_list_scroll_controller.dart';

class PowerListScrollSimulationController
    extends PowerListPageScrollController {
  PowerListScrollSimulationController({
    int initialPage = 0,
    bool keepPage = true,
    double viewportFraction = 1.0,
    bool isLoop = false,
  }) : super(
          initialPage: initialPage,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
          isLoop: isLoop,
        );

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return PowerListScrollSimulationPosition(
      physics: physics,
      context: context,
      isLoop: isLoop,
      initialPage: initialPage,
      keepPage: keepPage,
      oldPosition: oldPosition,
      viewportFraction: viewportFraction,
    );
  }
}

class PowerListScrollSimulationPosition extends PowerListPagePosition {
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
  PowerListScrollSimulationPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    int initialPage = 0,
    bool isLoop = false,
    bool keepPage = true,
    double viewportFraction = 1.0,
    ScrollPosition? oldPosition,
  }) : super(
          physics: physics,
          context: context,
          initialPage: initialPage,
          isLoop: isLoop,
          oldPosition: oldPosition,
          keepPage: keepPage,
          viewportFraction: viewportFraction,
        );

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
