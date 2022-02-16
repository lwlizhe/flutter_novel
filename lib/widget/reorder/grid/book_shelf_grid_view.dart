import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';

class BookShelfSliverGird extends SliverGrid {
  BookShelfSliverGird({
    Key? key,
    required SliverChildDelegate delegate,
    required SliverGridDelegate gridDelegate,
  }) : super(key: key, delegate: delegate, gridDelegate: gridDelegate);

  @override
  SliverMultiBoxAdaptorElement createElement() {
    return BookShelfSliverMultiBoxAdaptorElement(this);
  }

  @override
  RenderSliverGrid createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSliverGrid(childManager: element, gridDelegate: gridDelegate);
  }
}

class BookShelfSliverMultiBoxAdaptorElement
    extends SliverMultiBoxAdaptorElement {
  /// Creates an element that lazily builds children for the given widget.
  ///
  /// If `replaceMovedChildren` is set to true, a new child is proactively
  /// inflate for the index that was previously occupied by a child that moved
  /// to a new index. The layout offset of the moved child is copied over to the
  /// new child. RenderObjects, that depend on the layout offset of existing
  /// children during [RenderObject.performLayout] should set this to true
  /// (example: [RenderSliverList]). For RenderObjects that figure out the
  /// layout offset of their children without looking at the layout offset of
  /// existing children this should be set to false (example:
  /// [RenderSliverFixedExtentList]) to avoid inflating unnecessary children.
  BookShelfSliverMultiBoxAdaptorElement(SliverMultiBoxAdaptorWidget widget,
      {bool replaceMovedChildren = false})
      : _replaceMovedChildren = replaceMovedChildren,
        super(widget);

  final bool _replaceMovedChildren;

  @override
  SliverMultiBoxAdaptorWidget get widget => super.widget;

  @override
  RenderSliverMultiBoxAdaptor get renderObject => super.renderObject;

  @override
  void update(covariant SliverMultiBoxAdaptorWidget newWidget) {
    final SliverMultiBoxAdaptorWidget oldWidget = widget;
    super.update(newWidget);
    final SliverChildDelegate newDelegate = newWidget.delegate;
    final SliverChildDelegate oldDelegate = oldWidget.delegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType ||
            newDelegate.shouldRebuild(oldDelegate))) performRebuild();
  }

  final SplayTreeMap<int, Element?> _childElements =
      SplayTreeMap<int, Element?>();
  RenderBox? _currentBeforeChild;

  @override
  void performRebuild() {
    super.performRebuild();
    _currentBeforeChild = null;
    bool childrenUpdated = false;
    assert(_currentlyUpdatingChildIndex == null);
    try {
      final SplayTreeMap<int, Element?> newChildren =
          SplayTreeMap<int, Element?>();
      final Map<int, double> indexToLayoutOffset = HashMap<int, double>();
      void processElement(int index) {
        _currentlyUpdatingChildIndex = index;
        if (_childElements[index] != null &&
            _childElements[index] != newChildren[index]) {
          // This index has an old child that isn't used anywhere and should be deactivated.
          _childElements[index] =
              updateChild(_childElements[index], null, index);
          childrenUpdated = true;
        }
        final Element? newChild =
            updateChild(newChildren[index], _build(index), index);
        if (newChild != null) {
          childrenUpdated =
              childrenUpdated || _childElements[index] != newChild;
          _childElements[index] = newChild;
          final SliverMultiBoxAdaptorParentData parentData = newChild
              .renderObject!.parentData! as SliverMultiBoxAdaptorParentData;
          if (index == 0) {
            parentData.layoutOffset = 0.0;
          } else if (indexToLayoutOffset.containsKey(index)) {
            parentData.layoutOffset = indexToLayoutOffset[index];
          }
          if (!parentData.keptAlive)
            _currentBeforeChild = newChild.renderObject as RenderBox?;
        } else {
          childrenUpdated = true;
          _childElements.remove(index);
        }
      }

      for (final int index in _childElements.keys.toList()) {
        final Key? key = _childElements[index]!.widget.key;
        final int? newIndex =
            key == null ? null : widget.delegate.findIndexByKey(key);
        final SliverMultiBoxAdaptorParentData? childParentData =
            _childElements[index]!.renderObject?.parentData
                as SliverMultiBoxAdaptorParentData?;

        if (childParentData != null && childParentData.layoutOffset != null)
          indexToLayoutOffset[index] = childParentData.layoutOffset!;

        if (newIndex != null && newIndex != index) {
          // The layout offset of the child being moved is no longer accurate.
          if (childParentData != null) childParentData.layoutOffset = null;

          newChildren[newIndex] = _childElements[index];
          if (_replaceMovedChildren) {
            // We need to make sure the original index gets processed.
            newChildren.putIfAbsent(index, () => null);
          }
          // We do not want the remapped child to get deactivated during processElement.
          _childElements.remove(index);
        } else {
          newChildren.putIfAbsent(index, () => _childElements[index]);
        }
      }

      renderObject.debugChildIntegrityEnabled =
          false; // Moving children will temporary violate the integrity.
      newChildren.keys.forEach(processElement);
      // An element rebuild only updates existing children. The underflow check
      // is here to make sure we look ahead one more child if we were at the end
      // of the child list before the update. By doing so, we can update the max
      // scroll offset during the layout phase. Otherwise, the layout phase may
      // be skipped, and the scroll view may be stuck at the previous max
      // scroll offset.
      //
      // This logic is not needed if any existing children has been updated,
      // because we will not skip the layout phase if that happens.
      if (!childrenUpdated && _didUnderflow) {
        final int lastKey = _childElements.lastKey() ?? -1;
        final int rightBoundary = lastKey + 1;
        newChildren[rightBoundary] = _childElements[rightBoundary];
        processElement(rightBoundary);
      }
    } finally {
      _currentlyUpdatingChildIndex = null;
      renderObject.debugChildIntegrityEnabled = true;
    }
  }

  Widget? _build(int index) {
    return widget.delegate.build(this, index);
  }

  @override
  void createChild(int index, {required RenderBox? after}) {
    assert(_currentlyUpdatingChildIndex == null);
    owner!.buildScope(this, () {
      final bool insertFirst = after == null;
      assert(insertFirst || _childElements[index - 1] != null);
      _currentBeforeChild = insertFirst
          ? null
          : (_childElements[index - 1]!.renderObject as RenderBox?);
      Element? newChild;
      try {
        _currentlyUpdatingChildIndex = index;
        newChild = updateChild(_childElements[index], _build(index), index);
      } finally {
        _currentlyUpdatingChildIndex = null;
      }
      if (newChild != null) {
        _childElements[index] = newChild;
      } else {
        _childElements.remove(index);
      }
    });
  }

  @override
  Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
    final SliverMultiBoxAdaptorParentData? oldParentData =
        child?.renderObject?.parentData as SliverMultiBoxAdaptorParentData?;
    final Element? newChild = super.updateChild(child, newWidget, newSlot);
    final SliverMultiBoxAdaptorParentData? newParentData =
        newChild?.renderObject?.parentData as SliverMultiBoxAdaptorParentData?;

    // Preserve the old layoutOffset if the renderObject was swapped out.
    if (oldParentData != newParentData &&
        oldParentData != null &&
        newParentData != null) {
      newParentData.layoutOffset = oldParentData.layoutOffset;
    }
    return newChild;
  }

  @override
  void forgetChild(Element child) {
    assert(child != null);
    assert(child.slot != null);
    assert(_childElements.containsKey(child.slot));
    _childElements.remove(child.slot);
    super.forgetChild(child);
  }

  @override
  void removeChild(RenderBox child) {
    final int index = renderObject.indexOf(child);
    assert(_currentlyUpdatingChildIndex == null);
    assert(index >= 0);
    owner!.buildScope(this, () {
      assert(_childElements.containsKey(index));
      try {
        _currentlyUpdatingChildIndex = index;
        final Element? result = updateChild(_childElements[index], null, index);
        assert(result == null);
      } finally {
        _currentlyUpdatingChildIndex = null;
      }
      _childElements.remove(index);
      assert(!_childElements.containsKey(index));
    });
  }

  static double _extrapolateMaxScrollOffset(
    int firstIndex,
    int lastIndex,
    double leadingScrollOffset,
    double trailingScrollOffset,
    int childCount,
  ) {
    if (lastIndex == childCount - 1) return trailingScrollOffset;
    final int reifiedCount = lastIndex - firstIndex + 1;
    final double averageExtent =
        (trailingScrollOffset - leadingScrollOffset) / reifiedCount;
    final int remainingCount = childCount - lastIndex - 1;
    return trailingScrollOffset + averageExtent * remainingCount;
  }

  @override
  double estimateMaxScrollOffset(
    SliverConstraints? constraints, {
    int? firstIndex,
    int? lastIndex,
    double? leadingScrollOffset,
    double? trailingScrollOffset,
  }) {
    final int? childCount = estimatedChildCount;
    if (childCount == null) return double.infinity;
    return widget.estimateMaxScrollOffset(
          constraints,
          firstIndex!,
          lastIndex!,
          leadingScrollOffset!,
          trailingScrollOffset!,
        ) ??
        _extrapolateMaxScrollOffset(
          firstIndex,
          lastIndex,
          leadingScrollOffset,
          trailingScrollOffset,
          childCount,
        );
  }

  /// The best available estimate of [childCount], or null if no estimate is available.
  ///
  /// This differs from [childCount] in that [childCount] never returns null (and must
  /// not be accessed if the child count is not yet available, meaning the [createChild]
  /// method has not been provided an index that does not create a child).
  ///
  /// See also:
  ///
  ///  * [SliverChildDelegate.estimatedChildCount], to which this getter defers.
  int? get estimatedChildCount => widget.delegate.estimatedChildCount;

  @override
  int get childCount {
    int? result = estimatedChildCount;
    if (result == null) {
      // Since childCount was called, we know that we reached the end of
      // the list (as in, _build return null once), so we know that the
      // list is finite.
      // Let's do an open-ended binary search to find the end of the list
      // manually.
      int lo = 0;
      int hi = 1;
      const int max = kIsWeb
          ? 9007199254740992 // max safe integer on JS (from 0 to this number x != x+1)
          : ((1 << 63) - 1);
      while (_build(hi - 1) != null) {
        lo = hi - 1;
        if (hi < max ~/ 2) {
          hi *= 2;
        } else if (hi < max) {
          hi = max;
        } else {
          throw FlutterError(
            'Could not find the number of children in ${widget.delegate}.\n'
            "The childCount getter was called (implying that the delegate's builder returned null "
            'for a positive index), but even building the child with index $hi (the maximum '
            'possible integer) did not return null. Consider implementing childCount to avoid '
            'the cost of searching for the final child.',
          );
        }
      }
      while (hi - lo > 1) {
        final int mid = (hi - lo) ~/ 2 + lo;
        if (_build(mid - 1) == null) {
          hi = mid;
        } else {
          lo = mid;
        }
      }
      result = lo;
    }
    return result;
  }

  @override
  void didStartLayout() {
    assert(debugAssertChildListLocked());
  }

  @override
  void didFinishLayout() {
    assert(debugAssertChildListLocked());
    final int firstIndex = _childElements.firstKey() ?? 0;
    final int lastIndex = _childElements.lastKey() ?? 0;
    widget.delegate.didFinishLayout(firstIndex, lastIndex);
  }

  int? _currentlyUpdatingChildIndex;
  int? _currentlyInsertChildIndex;
  int? _currentlyInsertTargetChildIndex;

  @override
  bool debugAssertChildListLocked() {
    assert(_currentlyUpdatingChildIndex == null);
    return true;
  }

  bool _didUnderflow = false;

  @override
  void setDidUnderflow(bool value) {
    _didUnderflow = value;
  }

  @override
  void insertRenderObjectChild(covariant RenderObject child, int slot) {
    assert(slot != null);
    assert(_currentlyUpdatingChildIndex == slot);
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child as RenderBox, after: _currentBeforeChild);
    assert(() {
      final SliverMultiBoxAdaptorParentData childParentData =
          child.parentData! as SliverMultiBoxAdaptorParentData;
      assert(slot == childParentData.index);
      return true;
    }());
  }

  @override
  void moveRenderObjectChild(
      covariant RenderObject child, int oldSlot, int newSlot) {
    assert(newSlot != null);
    assert(_currentlyUpdatingChildIndex == newSlot);
    renderObject.move(child as RenderBox, after: _currentBeforeChild);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, int slot) {
    assert(_currentlyUpdatingChildIndex != null);
    renderObject.remove(child as RenderBox);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    // The toList() is to make a copy so that the underlying list can be modified by
    // the visitor:
    assert(!_childElements.values.any((Element? child) => child == null));
    _childElements.values.cast<Element>().toList().forEach(visitor);
  }

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    _childElements.values.cast<Element>().where((Element child) {
      final SliverMultiBoxAdaptorParentData parentData =
          child.renderObject!.parentData! as SliverMultiBoxAdaptorParentData;
      final double itemExtent;
      switch (renderObject.constraints.axis) {
        case Axis.horizontal:
          itemExtent = child.renderObject!.paintBounds.width;
          break;
        case Axis.vertical:
          itemExtent = child.renderObject!.paintBounds.height;
          break;
      }

      return parentData.layoutOffset != null &&
          parentData.layoutOffset! <
              renderObject.constraints.scrollOffset +
                  renderObject.constraints.remainingPaintExtent &&
          parentData.layoutOffset! + itemExtent >
              renderObject.constraints.scrollOffset;
    }).forEach(visitor);
  }

  @override
  void didAdoptChild(RenderBox child) {
    assert(_currentlyUpdatingChildIndex != null);
    final SliverMultiBoxAdaptorParentData childParentData =
        child.parentData! as SliverMultiBoxAdaptorParentData;
    childParentData.index = _currentlyUpdatingChildIndex;

    if (_currentlyInsertChildIndex != null &&
        _currentlyInsertTargetChildIndex != null) {
      if (_currentlyInsertChildIndex! < _currentlyInsertTargetChildIndex!) {
        var reOrderIndex = _currentlyInsertChildIndex! + 1;
        var reOrderElement = _childElements[reOrderIndex];
        var reOrderStartIndex = _currentlyUpdatingChildIndex! + 1;
        if (reOrderElement != null) {
          RenderBox? reOrderChild = reOrderElement.renderObject as RenderBox;
          while (reOrderChild != null) {
            var parentData = reOrderChild.parentData;
            if (parentData is SliverGridParentData) {
              parentData.index = reOrderStartIndex;
              reOrderStartIndex++;
            }

            reOrderChild = renderObject.childAfter(reOrderChild);
          }
        }
      } else {
        var reOrderIndex = _currentlyInsertChildIndex! - 1;
        var reOrderElement = _childElements[reOrderIndex];
        var reOrderStartIndex = _currentlyUpdatingChildIndex! - 1;
        if (reOrderElement != null) {
          RenderBox? reOrderChild = reOrderElement.renderObject as RenderBox;
          while (reOrderChild != null) {
            var parentData = reOrderChild.parentData;
            if (parentData is SliverGridParentData) {
              parentData.index = reOrderStartIndex;
              reOrderStartIndex--;
            }

            reOrderChild = renderObject.childBefore(reOrderChild);
          }
        }
      }
    }
  }

  void reorderRenderObjectChild(int toIndex, int fromIndex) {
    /// 防止大力出奇迹式超快速排序(在layout完成前多次触发重排序)导致出错
    if (this.renderObject.debugNeedsLayout) {
      return;
    }

    var fromItemRenderObject = _childElements[fromIndex]?.renderObject;
    var toItemRenderObject = _childElements[toIndex]?.renderObject;

    var itemOffsetList = <Offset>[];
    for (int i = 0; i < _childElements.keys.length; i++) {
      var elementKey = _childElements.keys.toList()[i];
      var itemParentData = _childElements[elementKey]?.renderObject?.parentData
          as SliverGridParentData?;
      itemOffsetList.add(Offset(itemParentData?.crossAxisOffset ?? 0,
          itemParentData?.layoutOffset ?? 0));
    }

    if (fromItemRenderObject != null) {
      var fromItem = _childElements[fromIndex];

      _currentlyUpdatingChildIndex =
          (toItemRenderObject?.parentData as SliverGridParentData?)?.index ??
              toIndex;

      if (toIndex < fromIndex) {
        for (int index = fromIndex; index > toIndex; index--) {
          var preItem =
              index - 1 < toIndex ? fromItem : _childElements[index - 1];
          _childElements[index] = preItem;
        }
      } else {
        for (int index = fromIndex; index < toIndex; index++) {
          var nextItem =
              index + 1 > toIndex ? fromItem : _childElements[index + 1];
          _childElements[index] = nextItem;
        }
      }

      _childElements[toIndex] = fromItem;

      _currentlyInsertChildIndex = toIndex;
      _currentlyInsertTargetChildIndex = fromIndex;

      var targetAfterBox =
          _childElements[toIndex - 1]?.renderObject as RenderBox;

      renderObject.move(fromItemRenderObject as RenderBox,
          after: targetAfterBox);

      for (int i = 0; i < _childElements.keys.length; i++) {
        var elementKey = _childElements.keys.toList()[i];
        var itemParentData = _childElements[elementKey]
            ?.renderObject
            ?.parentData as SliverGridParentData?;

        var itemData =
            BookShelfItemInheritedWidget.of(_childElements[elementKey]!)
                ?.itemData;
        itemData?.renderObjectIndex = itemParentData?.index;
        itemParentData?.crossAxisOffset = itemOffsetList[i].dx;
        itemParentData?.layoutOffset = itemOffsetList[i].dy;
      }

      _currentlyUpdatingChildIndex = null;
      _currentlyInsertChildIndex = null;
      _currentlyInsertTargetChildIndex = null;
    }
  }
}
