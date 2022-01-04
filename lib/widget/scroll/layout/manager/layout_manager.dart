import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class LayoutManager {
  late RenderSliverMultiBoxAdaptor sliver;

  @mustCallSuper
  void bind(RenderSliverMultiBoxAdaptor sliver, BuildContext context) {
    this.sliver = sliver;
  }

  double paintExtentOf(RenderBox child) {
    assert(child.hasSize);
    switch (sliver.constraints.axis) {
      case Axis.horizontal:
        return child.size.width;
      case Axis.vertical:
        return child.size.height;
    }
  }

  void onPaint(PaintingContext context, Offset offset);

  void setChildParentData(
      SliverConstraints constraints, SliverGeometry geometry) {}

  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! SliverMultiBoxAdaptorParentData)
      child.parentData = SliverMultiBoxAdaptorParentData();
  }

  double childMainAxisPosition(RenderBox child) {
    return sliver.childMainAxisPosition(child);
  }

  double childCrossAxisPosition(covariant RenderObject child) => 0.0;

  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (mainAxisPosition >= 0.0 &&
        mainAxisPosition < sliver.geometry!.hitTestExtent &&
        crossAxisPosition >= 0.0 &&
        crossAxisPosition < sliver.constraints.crossAxisExtent) {
      if (hitTestChildren(result,
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition) ||
          hitTestSelf(
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition)) {
        result.add(SliverHitTestEntry(
          sliver,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ));
        return true;
      }
    }
    return false;
  }

  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    RenderBox? child = sliver.lastChild;
    final BoxHitTestResult boxResult = BoxHitTestResult.wrap(result);
    while (child != null) {
      if (hitTestBoxChild(boxResult, child,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition)) return true;
      child = sliver.childBefore(child);
    }
    return false;
  }

  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    final bool rightWayUp = _getRightWayUp(sliver.constraints);
    double delta = childMainAxisPosition(child);
    final double crossAxisDelta = childCrossAxisPosition(child);
    double absolutePosition = mainAxisPosition - delta;
    final double absoluteCrossAxisPosition = crossAxisPosition - crossAxisDelta;
    Offset paintOffset, transformedPosition;
    switch (sliver.constraints.axis) {
      case Axis.horizontal:
        if (!rightWayUp) {
          absolutePosition = child.size.width - absolutePosition;
          delta = sliver.geometry!.paintExtent - child.size.width - delta;
        }
        paintOffset = Offset(delta, crossAxisDelta);
        transformedPosition =
            Offset(absolutePosition, absoluteCrossAxisPosition);
        break;
      case Axis.vertical:
        if (!rightWayUp) {
          absolutePosition = child.size.height - absolutePosition;
          delta = sliver.geometry!.paintExtent - child.size.height - delta;
        }
        paintOffset = Offset(crossAxisDelta, delta);
        transformedPosition =
            Offset(absoluteCrossAxisPosition, absolutePosition);
        break;
    }

    return result.addWithOutOfBandPosition(
      paintOffset: paintOffset,
      hitTest: (BoxHitTestResult result) {
        return child.hitTest(result, position: transformedPosition);
      },
    );
  }

  bool hitTestSelf(
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return false;
  }

  void applyPaintTransformForBoxChild(RenderBox child, Matrix4 transform) {
    final bool rightWayUp = _getRightWayUp(sliver.constraints);
    double delta = childMainAxisPosition(child);
    final double crossAxisDelta = childCrossAxisPosition(child);
    switch (sliver.constraints.axis) {
      case Axis.horizontal:
        if (!rightWayUp)
          delta = sliver.geometry!.paintExtent - child.size.width - delta;
        transform.translate(delta, crossAxisDelta);
        break;
      case Axis.vertical:
        if (!rightWayUp)
          delta = sliver.geometry!.paintExtent - child.size.height - delta;
        transform.translate(crossAxisDelta, delta);
        break;
    }
  }

  bool _getRightWayUp(SliverConstraints constraints) {
    bool rightWayUp;
    switch (constraints.axisDirection) {
      case AxisDirection.up:
      case AxisDirection.left:
        rightWayUp = false;
        break;
      case AxisDirection.down:
      case AxisDirection.right:
        rightWayUp = true;
        break;
    }
    switch (constraints.growthDirection) {
      case GrowthDirection.forward:
        break;
      case GrowthDirection.reverse:
        rightWayUp = !rightWayUp;
        break;
    }
    return rightWayUp;
  }
}

/// 线性布局的layoutManager 默认用的这个
class PowerListLinearLayoutManager extends LayoutManager {
  @override
  void onPaint(PaintingContext context, Offset offset) {
    if (sliver.firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    final Offset mainAxisUnit, crossAxisUnit, originOffset;
    final bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        sliver.constraints.axisDirection, sliver.constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, sliver.geometry!.paintExtent);
        addExtent = true;
        break;
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(sliver.geometry!.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    RenderBox? child = sliver.firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = 0;
      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );
      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.

      if (mainAxisDelta < sliver.constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) >= 0)
        context.paintChild(child, childOffset);

      child = sliver.childAfter(child);
    }
  }
}
