import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_grid_view.dart';

import 'item/book_shelf_reorder_grid_item.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class BookShelfGrid extends GridView {
  final GlobalKey sliverGridKey;
  final ReOrderCallback onReOrder;

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
  }) : super.custom(
          gridDelegate: gridDelegate,
          childrenDelegate: BookShelfSliverChildBuilderDelegate(
              (context, index) {
            return BookShelfReorderGridAnimatedItem(
              itemBuilder.call(context, index),
              index,
              (toIndex, fromIndex) {
                var element =
                    (context as BookShelfSliverMultiBoxAdaptorElement);

                element.reorderRenderObjectChild(toIndex, fromIndex);

                context.findRenderObject()?.markNeedsLayout();
              },
              () {
                var operateIndexList =
                    BookShelfListDataInheritedWidget.of(context)
                        ?.currentOperateIndexList;
                if ((operateIndexList?[1] ?? -1) != -1 &&
                    (operateIndexList?[0] ?? -1) != -1) {
                  onReOrder.call(
                      operateIndexList?[1] ?? 0, operateIndexList?[0] ?? 0);
                  operateIndexList = [0, 0];
                  context.findRenderObject()?.markNeedsLayout();
                }
              },
              key: ValueKey(index),
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
      currentItemValueIndexList: [],
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

  List<int>? currentItemIndexList;
  GlobalKey? gridKey;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    super.didFinishLayout(firstIndex, lastIndex);
    currentItemIndexList?.clear();
    // currentReOrderPositionMap?.clear();

    gridKey?.currentContext?.visitChildElements((element) {
      var itemDataInheritedWidget = BookShelfItemInheritedWidget.of(element);
      var itemData = itemDataInheritedWidget?.itemData;

      var gridData = element.findRenderObject()?.parentData;
      if (gridData is SliverGridParentData) {
        if (gridData.index != null) {
          var newItemOffset =
              Offset(gridData.crossAxisOffset ?? 0, gridData.layoutOffset ?? 0);
          currentItemIndexList?.add(itemData?.itemIndex ?? 0);

          if (itemData != null) {
            if (itemData.renderObjectIndex != gridData.index) {
              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                element.visitChildElements((element) {
                  itemData.renderObjectIndex = gridData.index!;

                  itemData.transformOffset = Offset(
                      newItemOffset.dx - (itemData.currentOffset.dx),
                      newItemOffset.dy - (itemData.currentOffset.dy));
                  itemData.currentOffset = Offset(gridData.crossAxisOffset ?? 0,
                      gridData.layoutOffset ?? 0);
                  element.markNeedsBuild();
                });
              });
            } else {
              itemData.currentOffset = newItemOffset;
              itemData.transformOffset = itemData.currentOffset;
            }
          }
        }
      }
    });

    print(
        ' ----------------------- didFinishLayout -------------------------- ');
  }

  @override
  int? findIndexByKey(Key key) {
    return super.findIndexByKey(key);
  }

  @override
  Widget? build(BuildContext context, int index) {
    currentItemIndexList =
        BookShelfListDataInheritedWidget.of(context)?.currentItemValueIndexList;
    if (index < 0 || (childCount != null && index >= childCount!)) return null;

    return BookShelfItemInheritedWidget(
        itemIndex: index,
        renderObjectIndex: index,
        child: builder(context, index)!);
  }
}

class BookShelfListDataInheritedWidget extends InheritedWidget {
  BookShelfListDataInheritedWidget({
    Key? key,
    required this.currentItemValueIndexList,
    required this.currentOperateIndexList,
    required Widget child,
  }) : super(key: key, child: child);

  final List<int> currentItemValueIndexList;
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

class BookShelfItemInheritedWidget extends InheritedWidget {
  BookShelfItemInheritedWidget({
    Key? key,
    required int itemIndex,
    required int renderObjectIndex,
    required Widget child,
  }) : super(key: key, child: child) {
    itemData.renderObjectIndex = renderObjectIndex;
    itemData.itemIndex = itemIndex;
  }

  final itemData = ItemData();

  static BookShelfItemInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BookShelfItemInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class ItemData {
  int itemIndex = -1;
  int renderObjectIndex = -1;
  Offset transformOffset = Offset.zero;
  Offset currentOffset = Offset.zero;
}
