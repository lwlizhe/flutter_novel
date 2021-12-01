import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/data/power_list_parent_data.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/layout/manager/simulation/helper/power_list_simulation_helper.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';

class PowerListSimulationTurnLayoutManager extends LayoutManager {
  SimulationTurnPagePainterHelper helper = SimulationTurnPagePainterHelper();
  @override
  void onPaint(PaintingContext context, Offset offset) {
    if (sliver.firstChild == null) return;

    RenderBox? child = sliver.lastChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      if (mainAxisDelta + paintExtentOf(child) > 0) {
        if (mainAxisDelta <= 0) {
          paintFirstPage(context, child, mainAxisDelta);
        } else {
          context.paintChild(child, Offset(0, 0));
        }
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

  @override
  double childMainAxisPosition(RenderBox child) {
    return super.childMainAxisPosition(child);
  }

  void paintFirstPage(
      PaintingContext context, RenderBox child, double mainAxisDelta) {
    context.canvas.saveLayer(Offset.zero & child.size, Paint());

    context.paintChild(child, Offset(0, 0));

    var _gestureDataNotify =
        PowerListDataInheritedWidget.of(sliver.context)?.gestureNotify;
    helper.currentSize = child.size;

    if (_gestureDataNotify != null && _gestureDataNotify.pointerEvent != null) {
      helper.dispatchPointerEvent(
          _gestureDataNotify.pointerEvent!, child, mainAxisDelta);
    }

    helper.clearBottomCanvasArea(context.canvas);
    context.canvas.restore();
  }
}
