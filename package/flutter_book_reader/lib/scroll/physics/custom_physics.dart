import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomPagePhysics extends PageScrollPhysics {
  const CustomPagePhysics({super.parent});

  @override
  PageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPagePhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
          const SpringDescription(mass: 40, stiffness: 1000, damping: 0.75),
          position.pixels,
          target,
          velocity,
          tolerance: tolerance);
    }
    return null;
  }

  double _getPage(ScrollMetrics position) {
    if (position is PageMetrics) {
      return position.page!;
    }
    return position.pixels / position.viewportDimension;
  }

  double _getPixels(ScrollMetrics position, double page) {
    if (position is PageMetrics) {
      return getPixelsFromPage(page, position);
    }
    return page * position.viewportDimension;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return _getPixels(position, page.roundToDouble());
  }

  double getPixelsFromPage(double page, PageMetrics metrics) {
    return page * metrics.viewportDimension * metrics.viewportFraction +
        math.max(
            0, metrics.viewportDimension * (metrics.viewportFraction - 1) / 2);
  }
}
