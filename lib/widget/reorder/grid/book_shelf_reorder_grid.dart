import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_grid_view.dart';

import 'item/book_shelf_reorder_grid_item.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

class BookShelfGrid extends GridView {
  final GlobalKey sliverGridKey;
  final ReOrderCallback onWillAcceptCallback;

  BookShelfGrid.builder({
    Key? key,
    required this.sliverGridKey,
    required this.onWillAcceptCallback,
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
                (newIndex, oldIndex) {
                  print('newIndex : $newIndex , oldIndex : $oldIndex');
                  // (context as BookShelfSliverMultiBoxAdaptorElement)
                  //     .reorderRenderObjectChild(oldIndex, newIndex);
                  (context as Element).markNeedsBuild();
                  // context.markNeedsBuild();
                  // sliverGridKey.currentContext?.visitChildElements((element) {
                  //   element.markNeedsBuild();
                  // });
                  // (sliverGridKey.currentContext as Element).markNeedsBuild();
                },
                () {
                  // onWillAcceptCallback.call(6, 3);
                  // sliverGridKey.currentContext
                  //     ?.findRenderObject()
                  //     ?.markNeedsLayout();
                },
                // key: ValueKey(index.toString()),
              );
            },
            sliverGridKey,
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),
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
    return BookShelfItemPositionInheritedWidget(
      posList: [],
      reOrderPosList: [],
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

  List<Offset>? currentPositionList;
  List<Offset>? currentReOrderPositionList;
  GlobalKey? gridKey;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    super.didFinishLayout(firstIndex, lastIndex);
    currentPositionList?.clear();
    currentReOrderPositionList?.clear();

    gridKey?.currentContext?.visitChildElements((element) {
      var gridData = element.findRenderObject()?.parentData;
      if (gridData is SliverGridParentData) {
        if (currentPositionList != null) {
          currentPositionList!.add(Offset(
              gridData.crossAxisOffset ?? 0, gridData.layoutOffset ?? 0));
        }
      }
    });

    if (currentReOrderPositionList != null) {
      currentReOrderPositionList!.addAll(currentPositionList ?? []);
    }
  }

  @override
  Widget? build(BuildContext context, int index) {
    currentPositionList =
        BookShelfItemPositionInheritedWidget.of(context)?.posList;
    currentReOrderPositionList =
        BookShelfItemPositionInheritedWidget.of(context)?.reOrderPosList;
    return super.build(context, index);
  }
}

class BookShelfItemPositionInheritedWidget extends InheritedWidget {
  BookShelfItemPositionInheritedWidget({
    Key? key,
    required this.posList,
    required this.reOrderPosList,
    required Widget child,
  }) : super(key: key, child: child);

  final List<Offset> posList;
  final List<Offset> reOrderPosList;

  static BookShelfItemPositionInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        BookShelfItemPositionInheritedWidget>();
  }

  @override
  bool updateShouldNotify(
      covariant BookShelfItemPositionInheritedWidget oldWidget) {
    return (oldWidget.posList != this.posList) ||
        (oldWidget.reOrderPosList != this.reOrderPosList);
  }
}
