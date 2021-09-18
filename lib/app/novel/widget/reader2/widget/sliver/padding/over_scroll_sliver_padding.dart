import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OverScrollSliverPadding extends SliverPadding {
  OverScrollSliverPadding({
    Key? key,
    required EdgeInsetsGeometry padding,
    Widget? sliver,
  }) : super(key: key, padding: padding, sliver: sliver);

  @override
  OverScrollRenderSliverPadding createRenderObject(BuildContext context) {
    return OverScrollRenderSliverPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, OverScrollRenderSliverPadding renderObject) {
    renderObject
      ..padding = padding
      ..textDirection = Directionality.of(context);
  }
}

class OverScrollRenderSliverPadding extends RenderSliverPadding {
  OverScrollRenderSliverPadding({
    required EdgeInsetsGeometry padding,
    TextDirection? textDirection,
    RenderSliver? child,
  }) : super(padding: padding, textDirection: textDirection, child: child);

  @override
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return hitTestChildren(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
    // if (mainAxisPosition >= 0.0 && mainAxisPosition < geometry!.hitTestExtent &&
    //     crossAxisPosition >= 0.0 && crossAxisPosition < constraints.crossAxisExtent) {
    //   if (hitTestChildren(result, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition) ||
    //       hitTestSelf(mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition)) {
    //     result.add(SliverHitTestEntry(
    //       this,
    //       mainAxisPosition: mainAxisPosition,
    //       crossAxisPosition: crossAxisPosition,
    //     ));
    //     return true;
    //   }
    // }
    // return false;
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;
      result.addWithAxisOffset(
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
        mainAxisOffset: childMainAxisPosition(child!),
        crossAxisOffset: childCrossAxisPosition(child!),
        paintOffset: childParentData.paintOffset,
        hitTest: child!.hitTest,
      );
    }
    return false;
  }
}
