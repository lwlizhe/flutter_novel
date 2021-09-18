import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:flutter_novel/app/novel/widget/reader2/widget/layout/recycler_view_layout_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/sliver/recycler_sliver.dart';
import 'package:flutter/foundation.dart';

class RecyclerRenderSliverList extends RenderSliverMultiBoxAdaptor {
  /// Creates a sliver that places multiple box children in a linear array along
  /// the main axis.
  ///
  /// The [childManager] argument must not be null.
  RecyclerRenderSliverList({
    required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    BoxConstraints childConstraints = constraints.asBoxConstraints();
    /// todo : 改变child 的 布局约束，让其可以自适应
    childConstraints = BoxConstraints(
        minWidth: 0,
        maxWidth: childConstraints.maxWidth,
        minHeight: 0,
        maxHeight: childConstraints.maxHeight);
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

    // This algorithm in principle is straight-forward: find the first child
    // that overlaps the given scrollOffset, creating more children at the top
    // of the list if necessary, then walk down the list updating and laying out
    // each child and adding more at the end if necessary until we have enough
    // children to cover the entire viewport.
    //
    // It is complicated by one minor issue, which is that any time you update
    // or create a child, it's possible that the some of the children that
    // haven't yet been laid out will be removed, leaving the list in an
    // inconsistent state, and requiring that missing nodes be recreated.
    //
    // To keep this mess tractable, this algorithm starts from what is currently
    // the first child, if any, and then walks up and/or down from there, so
    // that the nodes that might get removed are always at the edges of what has
    // already been laid out.

    // Make sure we have at least one child to start from.
    if (firstChild == null) {
      if (!addInitialChild()) {
        // There are no children.
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    // We have at least one child.

    // These variables track the range of children that we have laid out. Within
    // this range, the children have consecutive indices. Outside this range,
    // it's possible for a child to get removed without notice.
    RenderBox? leadingChildWithLayout, trailingChildWithLayout;

    RenderBox? earliestUsefulChild = firstChild;

    // A firstChild with null layout offset is likely a result of children
    // reordering.
    //
    // We rely on firstChild to have accurate layout offset. In the case of null
    // layout offset, we have to find the first child that has valid layout
    // offset.
    if (childScrollOffset(firstChild!) == null) {
      int leadingChildrenWithoutLayoutOffset = 0;
      while (earliestUsefulChild != null &&
          childScrollOffset(earliestUsefulChild) == null) {
        earliestUsefulChild = childAfter(earliestUsefulChild);
        leadingChildrenWithoutLayoutOffset += 1;
      }
      // We should be able to destroy children with null layout offset safely,
      // because they are likely outside of viewport
      collectGarbage(leadingChildrenWithoutLayoutOffset, 0);
      // If can not find a valid layout offset, start from the initial child.
      if (firstChild == null) {
        if (!addInitialChild()) {
          // There are no children.
          geometry = SliverGeometry.zero;
          childManager.didFinishLayout();
          return;
        }
      }
    }

    // Find the last child that is at or before the scrollOffset.
    earliestUsefulChild = firstChild;
    for (double earliestScrollOffset = childScrollOffset(earliestUsefulChild!)!;
        earliestScrollOffset > scrollOffset;
        earliestScrollOffset = childScrollOffset(earliestUsefulChild)!) {
      // We have to add children before the earliestUsefulChild.
      earliestUsefulChild =
          insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      if (earliestUsefulChild == null) {
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;

        if (scrollOffset == 0.0) {
          // insertAndLayoutLeadingChild only lays out the children before
          // firstChild. In this case, nothing has been laid out. We have
          // to lay out firstChild manually.
          firstChild!.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          // We ran out of children before reaching the scroll offset.
          // We must inform our parent that this sliver cannot fulfill
          // its contract and that we need a scroll offset correction.
          geometry = SliverGeometry(
            scrollOffsetCorrection: -scrollOffset,
          );
          return;
        }
      }

      final double firstChildScrollOffset =
          earliestScrollOffset - paintExtentOf(firstChild!);
      // firstChildScrollOffset may contain double precision error
      if (firstChildScrollOffset < -precisionErrorTolerance) {
        // Let's assume there is no child before the first child. We will
        // correct it on the next layout if it is not.
        geometry = SliverGeometry(
          scrollOffsetCorrection: -firstChildScrollOffset,
        );
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;
        return;
      }

      final SliverMultiBoxAdaptorParentData childParentData =
          earliestUsefulChild.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = firstChildScrollOffset;
      assert(earliestUsefulChild == firstChild);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    assert(childScrollOffset(firstChild!)! > -precisionErrorTolerance);

    // If the scroll offset is at zero, we should make sure we are
    // actually at the beginning of the list.
    if (scrollOffset < precisionErrorTolerance) {
      // We iterate from the firstChild in case the leading child has a 0 paint
      // extent.
      while (indexOf(firstChild!) > 0) {
        final double earliestScrollOffset = childScrollOffset(firstChild!)!;
        // We correct one child at a time. If there are more children before
        // the earliestUsefulChild, we will correct it once the scroll offset
        // reaches zero again.
        earliestUsefulChild =
            insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
        assert(earliestUsefulChild != null);
        final double firstChildScrollOffset =
            earliestScrollOffset - paintExtentOf(firstChild!);
        final SliverMultiBoxAdaptorParentData childParentData =
            firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
        childParentData.layoutOffset = 0.0;
        // We only need to correct if the leading child actually has a
        // paint extent.
        if (firstChildScrollOffset < -precisionErrorTolerance) {
          geometry = SliverGeometry(
            scrollOffsetCorrection: -firstChildScrollOffset,
          );
          return;
        }
      }
    }

    // At this point, earliestUsefulChild is the first child, and is a child
    // whose scrollOffset is at or before the scrollOffset, and
    // leadingChildWithLayout and trailingChildWithLayout are either null or
    // cover a range of render boxes that we have laid out with the first being
    // the same as earliestUsefulChild and the last being either at or after the
    // scroll offset.

    assert(earliestUsefulChild == firstChild);
    assert(childScrollOffset(earliestUsefulChild!)! <= scrollOffset);

    // Make sure we've laid out at least one child.
    if (leadingChildWithLayout == null) {
      earliestUsefulChild!.layout(childConstraints, parentUsesSize: true);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
    }

    // Here, earliestUsefulChild is still the first child, it's got a
    // scrollOffset that is at or before our actual scrollOffset, and it has
    // been laid out, and is in fact our leadingChildWithLayout. It's possible
    // that some children beyond that one have also been laid out.

    bool inLayoutRange = true;
    RenderBox? child = earliestUsefulChild;
    int index = indexOf(child!);
    double endScrollOffset = childScrollOffset(child)! + paintExtentOf(child);
    bool advance() {
      // returns true if we advanced, false if we have no more children
      // This function is used in two different places below, to avoid code duplication.
      assert(child != null);
      if (child == trailingChildWithLayout) inLayoutRange = false;
      child = childAfter(child!);
      if (child == null) inLayoutRange = false;
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child!) != index) {
          // We are missing a child. Insert it (and lay it out) if possible.
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          if (child == null) {
            // We have run out of children.
            return false;
          }
        } else {
          // Lay out the child.
          child!.layout(childConstraints, parentUsesSize: true);
        }
        trailingChildWithLayout = child;
      }
      assert(child != null);
      final SliverMultiBoxAdaptorParentData childParentData =
          child!.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset = endScrollOffset;
      assert(childParentData.index == index);
      endScrollOffset = childScrollOffset(child!)! + paintExtentOf(child!);
      return true;
    }

    // Find the first child that ends after the scroll offset.
    while (endScrollOffset < scrollOffset) {
      leadingGarbage += 1;
      if (!advance()) {
        assert(leadingGarbage == childCount);
        assert(child == null);
        // we want to make sure we keep the last child around so we know the end scroll offset
        collectGarbage(leadingGarbage - 1, 0);
        assert(firstChild == lastChild);
        final double extent =
            childScrollOffset(lastChild!)! + paintExtentOf(lastChild!);
        geometry = SliverGeometry(
          scrollExtent: extent,
          paintExtent: 0.0,
          maxPaintExtent: extent,
        );
        return;
      }
    }

    // Now find the first child that ends after our end.
    while (endScrollOffset < targetEndScrollOffset) {
      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    // Finally count up all the remaining children and label them as garbage.
    if (child != null) {
      child = childAfter(child!);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child!);
      }
    }

    // At this point everything should be good to go, we just have to clean up
    // the garbage and report the geometry.

    collectGarbage(leadingGarbage, trailingGarbage);

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    final double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endScrollOffset,
      );
      assert(estimatedMaxScrollOffset >=
          endScrollOffset - childScrollOffset(firstChild!)!);
    }
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint ||
          constraints.scrollOffset > 0.0,
    );

    final ContainerParentDataMixin childParentData =
        firstChild!.parentData! as ContainerParentDataMixin;

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == endScrollOffset)
      childManager.setDidUnderflow(true);
    childManager.didFinishLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // super.paint(context, offset);
    // TODO: 这里可以视为ItemTouchHelper的部分？onDrawOver那些?；

    // 真正绘制子View，相当于Android 中 recyclerView的draw方法？
    var firstChildBox = firstChild;
    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    Offset? mainAxisUnit, crossAxisUnit, originOffset;
    bool? addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry!.paintExtent);
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
        originOffset = offset + Offset(geometry!.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    assert(mainAxisUnit != null);
    assert(addExtent != null);

    /// todo ： 决定显示顺序，注意结尾对应的childBefore/childAfter
    RenderBox? child = firstChild;

    var layoutManager =
        (childManager as RecyclerSliverMultiBoxAdaptorElement).layoutManager;
    var itemDecorationList = layoutManager != null
        ? layoutManager.itemDecorationList
        : <ItemDecoration>[];

    if (child != null) {
      // Offset extraPadding = Offset.zero;

      if (itemDecorationList.isNotEmpty) {
        ItemDecorationState decorationState = ItemDecorationState();
        itemDecorationList.forEach((decoration) {
          decoration.onDraw(context.canvas, decorationState);
        });
      }
    }

    /// todo ： 测试一下基础布局计算是否正确

    Path? customPath;
    PathMetric? pm;
    double? length;
    if (layoutManager is PathLayoutManager) {
      customPath = layoutManager.path;

      var pathMetrics = customPath.computeMetrics(forceClosed: false);
      pm = pathMetrics.elementAt(0);
      length = pm.length;
    }

    while (child != null) {
      double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);

      final double? scrollOffset = childScrollOffset(child);

      // print(
      //     "-------------------------------------------------------------------");
      // print("index : " + index.toString());
      // print("mainAxisDelta : " +
      //     mainAxisDelta.toString() +
      //     " ,crossAxisDelta : " +
      //     crossAxisDelta.toString());
      // print("mainAxisUnit : " +
      //     mainAxisUnit.toString() +
      //     " ,crossAxisUnit : " +
      //     mainAxisUnit.toString());
      // print("isRepaintBoundary : " + child.isRepaintBoundary.toString());
      // print("originOffset : " + originOffset.toString());
      // print("scrollOffset : " + scrollOffset.toString());
      // print("parent : " + child.parentData.toString());
      // print("child : " + child.toString());
      // print(
      //     "-------------------------------------------------------------------");

      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );

      // Offset childOffset = Offset(
      //   originOffset.dx +
      //       mainAxisUnit.dx * mainAxisDelta +
      //       crossAxisUnit.dx * crossAxisDelta,
      //   originOffset.dy +
      //       mainAxisUnit.dy * mainAxisDelta +
      //       crossAxisUnit.dy * crossAxisDelta,
      // );

      /// todo:让所有item 初始的时候默认在初始0的位置，形成覆盖翻页的那个效果
      // switch (constraints.axis) {
      //   case Axis.horizontal:
      //     childOffset = Offset(math.min(childOffset.dx, 0), childOffset.dy);
      //     break;
      //   case Axis.vertical:
      //     childOffset = Offset(childOffset.dx, math.min(childOffset.dy, 0));
      //     break;
      // }

      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      ItemDecorationState decorationState = ItemDecorationState()
        ..itemOffset = childOffset;

      (child.parentData as RecyclerViewSliverMultiBoxAdaptorParentData)
          .itemState = decorationState;

      if (mainAxisDelta + paintExtentOf(child) > 0) {
        //   if (mainAxisDelta < constraints.remainingPaintExtent &&
        //       mainAxisDelta + paintExtentOf(child) > 0) {
        void painter(PaintingContext context, Offset offset) {
          context.paintChild(
            child!,
            offset,
          );
        }

        // var itemTransform =
        //     layoutManager?.onPaintTransform(indexOf(child), decorationState);
        // if (itemTransform != null) {

        // } else {

        // context.paintChild(child, Offset(0,0));

        if (customPath != null) {
          var percent = (childOffset.dx + child.size.width) /
              (child.size.width + constraints.viewportMainAxisExtent);
          var tf = pm!.getTangentForOffset(length! * percent);
          print("test ：${tf?.position}");

          var childItemOffset = childOffset;

          if (tf?.position != null) {
            childItemOffset = Offset(
                tf!.position.dx - child.size.width / 2, tf.position.dy - 50);
          }

          // context.canvas.drawCircle(tf?.position??Offset(0, 0), 10, Paint()..color=Colors.white);
          context.pushTransform(
            needsCompositing,
            childItemOffset,
            Matrix4.identity(),
            // Pre-transform painting function.
            painter,
          );
        } else {
          context.paintChild(child, childOffset);
        }

        // }
        // child.markNeedsLayout();

        if (itemDecorationList.isNotEmpty) {
          itemDecorationList.forEach((decoration) {
            var resultRect = Rect.zero;

            decorationState.contentRangeRect = Rect.fromLTRB(
                resultRect.left + childOffset.dx,
                resultRect.top + childOffset.dy,
                resultRect.left + childOffset.dx,
                resultRect.left + childOffset.dy);

            decoration.onDrawOver(context.canvas, decorationState);
          });
        }
      }

      if (child.isRepaintBoundary) {}

      child = childAfter(child);
    }
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! RecyclerViewSliverMultiBoxAdaptorParentData)
      child.parentData = RecyclerViewSliverMultiBoxAdaptorParentData();
  }

  @override
  RenderBox? insertAndLayoutChild(BoxConstraints childConstraints,
      {RenderBox? after, bool parentUsesSize = false}) {
    return super.insertAndLayoutChild(childConstraints,
        after: after, parentUsesSize: parentUsesSize);
  }

  @override
  void collectGarbage(int leadingGarbage, int trailingGarbage) {
    if (leadingGarbage + trailingGarbage != 0) {
      print("collectGarbage : " +
          " leadingGarbage : " +
          leadingGarbage.toString() +
          ", trailingGarbage : " +
          trailingGarbage.toString());
    }

    super.collectGarbage(leadingGarbage, trailingGarbage);
  }

  @override
  bool hitTest(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    if (hitTestChildren(result,
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition) ||
        hitTestSelf(
            mainAxisPosition: mainAxisPosition,
            crossAxisPosition: crossAxisPosition)) {
      result.add(SliverHitTestEntry(
        this,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      ));
      return true;
    }
    return false;
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    RenderBox? child = lastChild;
    final BoxHitTestResult boxResult = BoxHitTestResult.wrap(result);
    while (child != null) {
      if (hitTestBoxChild(boxResult, child,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition)) return true;
      child = childBefore(child);
    }
    return false;
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    final bool rightWayUp = _getRightWayUp(constraints);
    double delta = childMainAxisPosition(child);
    final double crossAxisDelta = childCrossAxisPosition(child);
    double absolutePosition = mainAxisPosition - delta;
    final double absoluteCrossAxisPosition = crossAxisPosition - crossAxisDelta;
    Offset paintOffset, transformedPosition;
    assert(constraints.axis != null);
    switch (constraints.axis) {
      case Axis.horizontal:
        if (!rightWayUp) {
          absolutePosition = child.size.width - absolutePosition;
          delta = geometry!.paintExtent - child.size.width - delta;
        }
        paintOffset = Offset(delta, crossAxisDelta);

        transformedPosition =
            Offset(absolutePosition, absoluteCrossAxisPosition);
        break;
      case Axis.vertical:
        if (!rightWayUp) {
          absolutePosition = child.size.height - absolutePosition;
          delta = geometry!.paintExtent - child.size.height - delta;
        }
        paintOffset = Offset(crossAxisDelta, delta);
        transformedPosition =
            Offset(absoluteCrossAxisPosition, absolutePosition);
        break;
    }
    assert(paintOffset != null);
    assert(transformedPosition != null);

    var layoutManager =
        (childManager as RecyclerSliverMultiBoxAdaptorElement).layoutManager;
    if (layoutManager is PathLayoutManager) {
      var customPath = layoutManager.path;

      var pathMetrics = customPath.computeMetrics(forceClosed: false);
      var pm = pathMetrics.elementAt(0);
      var length = pm.length;

      var percent = (paintOffset.dx + child.size.width) /
          (child.size.width + constraints.viewportMainAxisExtent);
      var tf = pm!.getTangentForOffset(length! * percent);
      print("test ：${tf?.position}");


      if (tf?.position != null) {
        var tfPos = Offset(
            tf!.position.dx - child.size.width / 2, tf.position.dy - child.size.height / 2 );

        print('hit Test : ------------------------------------------------------------------------');
        print('hit Test : tfPos is $tfPos , child index is ${indexOf(child)}');
        print('hit Test : touchPos is : main $mainAxisPosition , cross $crossAxisPosition');
        var transformSize = child.size;

        if(transformSize.contains(Offset(mainAxisPosition-tfPos.dx, crossAxisPosition-tfPos.dy))){
          print('hit Test : pos contain');
          result.add(BoxHitTestEntry(child, Offset(mainAxisPosition,crossAxisPosition)));
        }
        print('hit Test : ------------------------------------------------------------------------');

      }

      return false;

    }


    // var banPositionResult = result.addWithOutOfBandPosition(
    //   paintOffset: paintOffset,
    //   hitTest: (BoxHitTestResult result) {
    //     var hitResult = child.hitTest(result, position: transformedPosition);
    //     if(hitResult){
    //       print('hit Test : hit true is $child , child index is ${indexOf(child)}');
    //     }
    //     return hitResult;
    //   },
    // );



    return false;
  }

  bool _getRightWayUp(SliverConstraints constraints) {
    assert(constraints != null);
    assert(constraints.axisDirection != null);
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
    assert(constraints.growthDirection != null);
    switch (constraints.growthDirection) {
      case GrowthDirection.forward:
        break;
      case GrowthDirection.reverse:
        rightWayUp = !rightWayUp;
        break;
    }
    assert(rightWayUp != null);
    return rightWayUp;
  }
}
