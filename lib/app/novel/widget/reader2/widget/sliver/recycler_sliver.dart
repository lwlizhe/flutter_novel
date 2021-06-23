import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:flutter_novel/app/novel/widget/reader2/widget/layout/recycler_view_layout_manager.dart';

class RecyclerSliverChildListDelegate extends SliverChildListDelegate {
  final LayoutManager? layoutManager;

  RecyclerSliverChildListDelegate(
    List<Widget> children,
    this.layoutManager, {
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    int semanticIndexOffset = 0,
  }) : super(children,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexOffset: semanticIndexOffset);

  @override
  Widget? build(BuildContext context, int index) {
    return super.build(context, index);
  }
}

class RecyclerSliverFixedExtentList extends SliverFixedExtentList {
  final LayoutManager? layoutManager;

  /// Creates a sliver that places box children with the same main axis extent
  /// in a linear array.
  RecyclerSliverFixedExtentList({
    Key? key,
    required SliverChildDelegate delegate,
    required itemExtent,
    this.layoutManager,
  }) : super(key: key, delegate: delegate, itemExtent: itemExtent);

  @override
  RenderSliverFixedExtentList createRenderObject(BuildContext context) {
    final RecyclerSliverMultiBoxAdaptorElement element =
        context as RecyclerSliverMultiBoxAdaptorElement;
    return RenderSliverFixedExtentList(
        childManager: element, itemExtent: itemExtent);
  }

  @override
  SliverMultiBoxAdaptorElement createElement() {
    return RecyclerSliverMultiBoxAdaptorElement(this, layoutManager);
  }
}

class RecyclerSliverList extends SliverList {
  final LayoutManager? layoutManager;

  const RecyclerSliverList({
    Key? key,
    required SliverChildDelegate delegate,
    this.layoutManager,
  }) : super(key: key, delegate: delegate);

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final RecyclerSliverMultiBoxAdaptorElement element =
        context as RecyclerSliverMultiBoxAdaptorElement;
    return RecyclerRenderSliverList(childManager: element);
  }

  @override
  SliverMultiBoxAdaptorElement createElement() {
    return RecyclerSliverMultiBoxAdaptorElement(this, layoutManager);
  }

// @override
// double estimateMaxScrollOffset(SliverConstraints constraints, int firstIndex, int lastIndex, double leadingScrollOffset, double trailingScrollOffset) {
//
//   // assert(lastIndex >= firstIndex);
//   // return delegate.estimateMaxScrollOffset(
//   //   firstIndex,
//   //   lastIndex,
//   //   leadingScrollOffset,
//   //   trailingScrollOffset,
//   // );
//   final int childCount = delegate.estimatedChildCount;
//   if (childCount == null)
//     return double.infinity;
//   if (lastIndex == childCount - 1)
//     return trailingScrollOffset;
//   final int reifiedCount = lastIndex - firstIndex + 1;
//   final double averageExtent = (trailingScrollOffset - leadingScrollOffset) / reifiedCount;
//   final int remainingCount = childCount - lastIndex - 1;
//   return trailingScrollOffset + averageExtent * remainingCount+100;
// }
}

class RecyclerSliverMultiBoxAdaptorElement
    extends SliverMultiBoxAdaptorElement {
  LayoutManager? _layoutManager;

  List<Element?> cacheElement = List.filled(100, null, growable: false);

  LayoutManager? get layoutManager => _layoutManager;

  RecyclerSliverMultiBoxAdaptorElement(
      SliverMultiBoxAdaptorWidget widget, this._layoutManager)
      : super(widget);

  @override
  void createChild(int index, {RenderBox? after}) {
    print("createChild : " + index.toString());
    super.createChild(index, after: after);
  }

  @override
  Element? updateChild(Element? child, Widget? newWidget, newSlot) {
    if (newSlot is int) {
      print("updateChild : " + newSlot.toString());
      if (child != null) {
        print("updateChild : child" + child.toString());
      }
      if (newWidget != null) {
        print("updateChild : newWidget" + newWidget.toString());
      }
    }

    // if (newWidget == null) {
    //   if (child != null) {
    //     cacheElement[newSlot] = child;
    //   }
    //   return null;
    // }
    //
    // if (cacheElement[newSlot] != null) {
    //   return super.updateChild(cacheElement[newSlot], newWidget, newSlot);
    // }

    return super.updateChild(child, newWidget, newSlot);
  }
}

class RecyclerRenderSliverList extends RenderSliverList {
  RecyclerRenderSliverList({
    required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  @override
  void paint(PaintingContext context, Offset offset) {
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
    RenderBox? child = lastChild;
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

      switch (constraints.axis) {
        case Axis.horizontal:
          childOffset = Offset(math.min(childOffset.dx, 0), childOffset.dy);
          break;
        case Axis.vertical:
          childOffset = Offset(childOffset.dx, math.min(childOffset.dy, 0));
          break;
      }

      // childOffset = Offset(math.min(childOffset.dx, 0), childOffset.dy);

      // print("childOffset : " + childOffset.toString());

      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      var layoutManager =
          (childManager as RecyclerSliverMultiBoxAdaptorElement).layoutManager;
      var itemDecorationList = layoutManager != null
          ? layoutManager.itemDecorationList
          : <ItemDecoration>[];

      ItemDecorationState decorationState = ItemDecorationState()
        ..itemOffset = childOffset;

      Offset extraPadding = Offset.zero;

      if (itemDecorationList.isNotEmpty) {
        itemDecorationList.forEach((decoration) {
          var resultPaddingOffset =
              decoration.getItemOffsets(childOffset, child, decorationState);

          extraPadding = resultPaddingOffset;
          mainAxisDelta -= extraPadding.dx;
          // if (child.hasSize &&
          //     (child.size.width != resultPaddingRect.width &&
          //     child.size.height != resultPaddingRect.height)) {
          //   child.markNeedsLayout();
          //   child.layout(BoxConstraints(maxWidth: resultPaddingRect.width));
          // }

          if (childOffset.dx != resultPaddingOffset.dx ||
              childOffset.dy != resultPaddingOffset.dy) {
            childOffset = resultPaddingOffset;
            decorationState.itemOffset = childOffset;
          }

          decoration.onDraw(context.canvas, decorationState);
        });
      }

      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0) {
        context.paintChild(child, childOffset);
      }

      if (child.isRepaintBoundary) {}

      if (itemDecorationList.isNotEmpty) {
        itemDecorationList.forEach((decoration) {
          decoration.onDrawOver(context.canvas, decorationState);
        });
      }

      child = childBefore(child);
    }
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

      if (childCount >= leadingGarbage + trailingGarbage) {
        int tempLeadingGarbage = leadingGarbage;
        int tempTrailingGarbage = trailingGarbage;

        RenderObject? tempFirstChild = firstChild;
        RenderObject? tempLastChild = lastChild;

        while (tempLeadingGarbage > 0) {
          (tempFirstChild!.parentData as SliverMultiBoxAdaptorParentData)
              .keepAlive = true;
          tempFirstChild = childAfter(tempFirstChild as RenderBox);
          tempLeadingGarbage -= 1;
        }

        while (tempTrailingGarbage > 0) {
          (tempLastChild!.parentData as SliverMultiBoxAdaptorParentData)
              .keepAlive = true;
          tempLastChild = childBefore(tempLastChild as RenderBox);
          tempTrailingGarbage -= 1;
        }
      }
    }

    super.collectGarbage(leadingGarbage, trailingGarbage);
  }
}

extension ExtendRect on Rect {
  bool isEqual(Rect target) {
    if (target == null) {
      return false;
    }

    return target.left == this.left &&
        target.top == this.top &&
        target.right == this.right &&
        target.bottom == this.bottom;
  }
}

class RecyclerRenderSliverFixedExtentList extends RenderSliverFixedExtentList {
  RecyclerRenderSliverFixedExtentList({
    required RenderSliverBoxChildManager childManager,
    required double itemExtent,
  }) : super(childManager: childManager, itemExtent: itemExtent);

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    context.canvas.drawRect(
        Rect.fromLTRB(0, 0, 100, 100), new Paint()..color = Colors.black);
  }
}
