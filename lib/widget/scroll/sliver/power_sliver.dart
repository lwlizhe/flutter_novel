import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/scroll/layout/manager/layout_manager.dart';
import 'package:flutter_novel/widget/scroll/sliver/power_sliver_fill.dart';
import 'package:flutter_novel/widget/scroll/sliver/power_sliver_list.dart';

class PowerSliverList extends SliverList {
  final LayoutManager layoutManager;

  PowerSliverList({
    Key? key,
    required SliverChildDelegate delegate,
    required this.layoutManager,
  }) : super(key: key, delegate: delegate);

  @override
  SliverMultiBoxAdaptorElement createElement() {
    var element =
        SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);
    return element;
  }

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return PowerRenderSliverList(
        childManager: element, layoutManager: layoutManager);
  }
}

class PowerSliverFillViewportRenderObjectWidget
    extends SliverMultiBoxAdaptorWidget {
  const PowerSliverFillViewportRenderObjectWidget({
    Key? key,
    required SliverChildDelegate delegate,
    required this.layoutManager,
    this.viewportFraction = 1.0,
  })  : assert(viewportFraction > 0.0),
        super(key: key, delegate: delegate);

  final double viewportFraction;
  final LayoutManager layoutManager;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return PowerRenderSliverFillViewport(
        childManager: element,
        viewportFraction: viewportFraction,
        layoutManager: layoutManager);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}
