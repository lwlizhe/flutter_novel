import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_grid_view.dart';

import 'item/book_shelf_reorder_grid_item.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

typedef BookShelfIndexContextCallback = Function(
    int index, ItemData? itemDataNotifier);

class BookShelfGrid extends GridView {
  final GlobalKey sliverGridKey;
  final ReOrderCallback onReOrder;
  final BookShelfIndexContextCallback? onDrag;
  final BookShelfIndexContextCallback? onMerge;

  BookShelfGrid.builder({
    Key? key,
    required this.sliverGridKey,
    required this.onReOrder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required SliverGridDelegate gridDelegate,
    required IndexedWidgetBuilder itemBuilder,
    int? itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.onDrag,
    this.onMerge,
  }) : super.custom(
          gridDelegate: gridDelegate,
          childrenDelegate: BookShelfSliverChildBuilderDelegate(
              (context, index) {
            return BookShelfReorderGridAnimatedItem(
              key: ValueKey(index),
              onReOrderCallback: (int toIndex, int fromIndex) {
                var element =
                    (context as BookShelfSliverMultiBoxAdaptorElement);

                element.reorderRenderObjectChild(toIndex, fromIndex);
              },
              index: index,
              onDragFinish: () {
                var operateIndexList =
                    BookShelfListDataInheritedWidget.of(context)
                        ?.currentOperateIndexList;
                if ((operateIndexList?[1] ?? -1) != -1 &&
                    (operateIndexList?[0] ?? -1) != -1) {
                  onReOrder.call(
                      operateIndexList?[1] ?? 0, operateIndexList?[0] ?? 0);
                  operateIndexList = [0, 0];
                }
                context.visitChildElements((element) {
                  var data = BookShelfItemInheritedWidget.of(element)?.itemData;
                  data?.resetState();
                });
                context.findRenderObject()?.markNeedsLayout();
              },
              onDragCallback: (index) {
                context.visitChildElements((element) {
                  var itemData = BookShelfItemInheritedWidget.of(element,
                          isDependent: false)!
                      .itemData;
                  if (index == itemData.itemIndex) {
                    onDrag?.call(index, itemData);
                    return;
                  }
                });
              },
              onMergeCallback: (index) {
                context.visitChildElements((element) {
                  var itemData = BookShelfItemInheritedWidget.of(element,
                          isDependent: false)!
                      .itemData;
                  if (index == itemData.itemIndex) {
                    itemData.toggleMergeTarget();
                    onMerge?.call(index, itemData);
                    return;
                  }
                });
              },
              child: itemBuilder.call(context, index),
            );
          }, sliverGridKey,
              childCount: itemCount,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              findChildIndexCallback: (key) {}),
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  @override
  Widget build(BuildContext context) {
    return BookShelfListDataInheritedWidget(
      currentOperateIndexList: [-1, -1],
      child: super.build(context),
    );
  }

  @override
  Widget buildChildLayout(BuildContext context) {
    return BookShelfSliverGird(
      key: sliverGridKey,
      delegate: childrenDelegate,
      gridDelegate: gridDelegate,
    );
  }
}

class BookShelfSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  BookShelfSliverChildBuilderDelegate(
    NullableIndexedWidgetBuilder builder,
    this.gridKey, {
    ChildIndexGetter? findChildIndexCallback,
    int? childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    SemanticIndexCallback semanticIndexCallback =
        _kDefaultSemanticIndexCallback,
    int semanticIndexOffset = 0,
  }) : super(
          builder,
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );

  GlobalKey? gridKey;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    super.didFinishLayout(firstIndex, lastIndex);

    gridKey?.currentContext?.visitChildElements((element) {
      var itemDataInheritedWidget =
          BookShelfItemInheritedWidget.of(element, isDependent: false);
      var itemData = itemDataInheritedWidget!.itemData;

      var gridData = element.findRenderObject()?.parentData;
      if (gridData is SliverGridParentData) {
        if (gridData.index != null) {
          var newItemOffset =
              Offset(gridData.crossAxisOffset ?? 0, gridData.layoutOffset ?? 0);
          itemData.currentOffset = newItemOffset;
        }
      }
    });
  }

  @override
  Widget? build(BuildContext context, int index) {
    if (index < 0 || (childCount != null && index >= childCount!)) return null;

    return BookShelfItemInheritedWidget(
        itemData: ItemData()
          ..itemIndex = index
          ..renderObjectIndex = index,
        child: builder(context, index)!);
  }
}

class BookShelfListDataInheritedWidget extends InheritedWidget {
  BookShelfListDataInheritedWidget({
    Key? key,
    required this.currentOperateIndexList,
    required Widget child,
  }) : super(key: key, child: child);

  final List<int> currentOperateIndexList;

  static BookShelfListDataInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BookShelfListDataInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class BookShelfItemInheritedWidget extends InheritedNotifier {
  BookShelfItemInheritedWidget({
    Key? key,
    required this.itemData,
    required Widget child,
  }) : super(key: key, child: child, notifier: itemData);

  final ItemData itemData;

  static BookShelfItemInheritedWidget? of(BuildContext context,
      {bool isDependent = true}) {
    if (context is Element) {
      if (context.widget is BookShelfItemInheritedWidget) {
        isDependent = false;
      }
    }
    if (isDependent) {
      return context
          .dependOnInheritedWidgetOfExactType<BookShelfItemInheritedWidget>();
    } else {
      return context
          .getElementForInheritedWidgetOfExactType<
              BookShelfItemInheritedWidget>()
          ?.widget as BookShelfItemInheritedWidget?;
    }
  }
}

class ItemData extends ChangeNotifier {
  int itemIndex = -1;
  int? renderObjectIndex = -1;
  Offset currentOffset = Offset(-1.0, -1.0);
  bool isMergeTarget = false;

  void setRenderObjectIndex(int? index) {
    renderObjectIndex = index;
    notifyListeners();
  }

  void toggleMergeTarget() {
    isMergeTarget = !isMergeTarget;
    notifyListeners();
  }

  void resetState() {
    isMergeTarget = false;
    notifyListeners();
  }

  @override
  String toString() {
    return 'itemIndex is $itemIndex , renderObjectIndex is $renderObjectIndex , currentOffset is $currentOffset , isMergeTarget is $isMergeTarget';
  }
}
