import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/widget/scroll/data/power_list_parent_data.dart';
import 'package:test_project/widget/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/widget/scroll/layout/manager/simulation/helper/power_list_simulation_helper.dart';
import 'package:test_project/widget/scroll/notify/power_list_data_notify.dart';

/// 经过测试，默认值1e-10其实还是不准的……
const double precisionErrorTolerance = 1e-8;

class PowerListSimulationTurnLayoutManager extends LayoutManager {
  SimulationTurnPagePainterHelper helper = SimulationTurnPagePainterHelper();

  String? logTag;

  BuildContext? _context;

  PowerListSimulationTurnLayoutManager({this.logTag});

  @override
  void bind(RenderSliverMultiBoxAdaptor sliver, BuildContext context) {
    super.bind(sliver, context);
    _context = context;
  }

  @override
  void onPaint(PaintingContext context, Offset offset) {
    if (sliver.firstChild == null) return;

    RenderBox? child = sliver.firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      var childExtent = paintExtentOf(child);
      if (mainAxisDelta + childExtent > 0 &&
          (mainAxisDelta.abs() - childExtent.abs()).abs() >
              precisionErrorTolerance) {
        if (mainAxisDelta < 0 &&
            mainAxisDelta.abs() > precisionErrorTolerance) {
          paintAnimationPage(
              context, child, sliver.childAfter(child), mainAxisDelta);
          break;
        } else {
          context.paintChild(child, Offset.zero);
        }
      }

      child = sliver.childAfter(child);
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

  void paintAnimationPage(PaintingContext context, RenderBox firstPageChild,
      RenderBox? nextPageChild, double mainAxisDelta) {
    /// 获取手势通知器
    var _gestureDataNotify =
        PowerListDataInheritedWidget.of(_context!)?.gestureNotify;

    /// 设置范围
    helper.currentSize = firstPageChild.size;

    /// 分发手势事件
    if (_gestureDataNotify != null && _gestureDataNotify.pointerEvent != null) {
      helper.dispatchPointerEvent(
          _gestureDataNotify.pointerEvent!, firstPageChild, mainAxisDelta);
    }

    /// 绘制
    helper.draw(context, firstPageChild, nextPageChild);
  }
}
