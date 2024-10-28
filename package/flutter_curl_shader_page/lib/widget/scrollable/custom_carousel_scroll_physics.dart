import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'custom_carousel_scroll_controller.dart';

/// A snapping physics that always settles directly on items instead of anywhere
/// within the scroll extent.
///
/// You can adjust the behavior by setting [sticky] or [stiffness].
///
/// Behaves similarly to a slot machine wheel except the ballistics simulation
/// never overshoots and rolls back within a single item if it's to settle on
/// that item.
///
/// Must be used with a scrollable that uses a [CustomCarouselScrollController].
///
/// Defers back to the parent beyond the scroll extents.
class CustomCarouselScrollPhysics extends BouncingScrollPhysics {
  /// Creates a scroll physics that always lands on items.
  const CustomCarouselScrollPhysics(
      {super.parent, this.sticky = false, this.stiffness = 1.0});

  /// If `true`, only advance by a single item when "throwing" the scroll.
  /// Note that it is still possible to advance through multiple items by dragging.
  /// This is similar to the default behavior of [PageView].
  /// Defaults to `false`.
  final bool sticky;

  /// Modifies the stiffness of the spring that controls the settling of the scroll view.
  /// A value below `1` will provide a looser feel, and a value above `1` will make it snappier.
  /// Values between `0.5` and `5` are recommended. Defaults to `1.0`.
  final double stiffness;

  @override
  CustomCarouselScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomCarouselScrollPhysics(
        parent: buildParent(ancestor), sticky: sticky, stiffness: stiffness);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    assert(
      position is CustomCarouselScrollPosition,
      'CustomCarouselScrollPhysics can only be used with Scrollables that use '
      'the CustomCarouselScrollController',
    );

    final CustomCarouselScrollPosition metrics =
        position as CustomCarouselScrollPosition;
    final double pixels = metrics.pixels;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation? testFrictionSimulation =
        super.createBallisticSimulation(metrics, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null &&
        (testFrictionSimulation.x(double.infinity) == metrics.minScrollExtent ||
            testFrictionSimulation.x(double.infinity) ==
                metrics.maxScrollExtent)) {
      return testFrictionSimulation;
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = metrics.getItemFromOffset(
      testFrictionSimulation?.x(double.infinity) ?? pixels,
    );

    double settlingPixels = settlingItemIndex * metrics.itemExtent;

    // if sticky, constrain the throw to advance by no more than a one item.
    if (sticky) {
      final double extent = metrics.itemExtent;
      final double delta = (settlingPixels - pixels) / extent;
      if (delta > 1 || delta < -1) {
        final int i = metrics.getItemFromOffset(pixels + extent * delta.sign);
        settlingPixels = i * extent;
      }
    }

    // use looser tolerance so we settle faster:
    final Tolerance tolerance = Tolerance(
      velocity: 10.0 / (0.050 *  WidgetsBinding.instance.window.devicePixelRatio),
      time: 0.01,
      distance: 1.0 / WidgetsBinding.instance.window.devicePixelRatio,
    );

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < tolerance.velocity &&
        (settlingPixels - metrics.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    // Create a new spring simulation that will land exactly on the item closest
    // to the natural stopping point.
    return SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1,
        // use a stiffer spring for closer items:
        stiffness: min(150, 1000 / sqrt((pixels - settlingPixels).abs()) + 15) *
            stiffness,
        ratio: 1.0,
      ),
      pixels,
      settlingPixels,
      velocity,
      tolerance: tolerance,
    );
  }
}
