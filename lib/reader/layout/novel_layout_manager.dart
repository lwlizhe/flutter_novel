import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:test_project/widget/scroll/data/power_list_parent_data.dart';
import 'package:test_project/widget/scroll/layout/manager/layout_manager.dart';

/// 覆盖翻页的layoutManager
/// 在这个模式下，要开启 repaintBoundary
class PowerListCoverLayoutManager extends LayoutManager {
  @override
  void onPaint(PaintingContext context, Offset offset) {
    if (sliver.firstChild == null) return;

    RenderBox? child = sliver.lastChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);

      if (mainAxisDelta < sliver.constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0) {
        var paintOffset =
            (child.parentData as PowerSliverListParentData).paintOffset;
        context.paintChild(child, paintOffset);
      }

      child = sliver.childBefore(child);
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! PowerSliverListParentData)
      child.parentData = PowerSliverListParentData();
  }

  @override
  void setChildParentData(
      SliverConstraints constraints, SliverGeometry geometry) {
    var currentChild = sliver.firstChild;
    while (currentChild != null) {
      var powerListData =
          (currentChild.parentData as PowerSliverListParentData);

      powerListData.paintOffset = Offset(
          min(((powerListData.layoutOffset ?? 0) - constraints.scrollOffset),
              0),
          0);

      currentChild = sliver.childAfter(currentChild);
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    RenderBox? child = sliver.firstChild;
    final BoxHitTestResult boxResult = BoxHitTestResult.wrap(result);
    while (child != null) {
      if (hitTestBoxChild(boxResult, child,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition)) return true;
      child = sliver.childAfter(child);
    }
    return false;
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    double delta = childMainAxisPosition(child);

    if (delta <= 0) {
      return super.hitTestBoxChild(result, child,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition);
    } else {
      return child.hitTest(result,
          position: Offset(mainAxisPosition, crossAxisPosition));
    }
  }
}
