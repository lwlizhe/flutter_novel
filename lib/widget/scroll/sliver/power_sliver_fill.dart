import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/scroll/layout/manager/layout_manager.dart';

class PowerRenderSliverFillViewport extends RenderSliverFillViewport {
  LayoutManager layoutManager;

  BuildContext get context => childManager as BuildContext;

  PowerRenderSliverFillViewport({
    required RenderSliverBoxChildManager childManager,
    required this.layoutManager,
    double viewportFraction = 1.0,
  }) : super(childManager: childManager, viewportFraction: viewportFraction) {
    layoutManager.bind(this, childManager as BuildContext);
  }

  @override
  void performLayout() {
    super.performLayout();
    layoutManager.setChildParentData(constraints, geometry!);
  }

  @override
  void setupParentData(covariant RenderObject child) {
    layoutManager.setupParentData(child);
  }

  @override
  void applyPaintTransform(covariant RenderBox child, Matrix4 transform) {
    super.applyPaintTransform(child, transform);
  }

  @override
  void applyPaintTransformForBoxChild(RenderBox child, Matrix4 transform) {
    layoutManager.applyPaintTransformForBoxChild(child, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // super.paint(context, offset);
    layoutManager.onPaint(context, offset);
  }

  @override
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return layoutManager.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return layoutManager.hitTestBoxChild(result, child,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  bool hitTestSelf(
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return layoutManager.hitTestSelf(
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return layoutManager.hitTestChildren(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }
}
