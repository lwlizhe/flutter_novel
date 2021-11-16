import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/sliver/power_sliver_list.dart';

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
