import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/animate/book_shelf_animated_container.dart';
import 'package:flutter_novel/widget/reorder/darg/book_shelf_drag_target.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';

typedef ReOrderCallback = Function(int toIndex, int fromIndex);
typedef BookShelfIndexCallback = Function(int index);

class BookShelfReorderGridAnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  final ReOrderCallback onReOrderCallback;
  final BookShelfIndexCallback? onDragCallback;
  final BookShelfIndexCallback? onMergeCallback;
  final VoidCallback onDragFinish;

  const BookShelfReorderGridAnimatedItem({
    Key? key,
    required this.child,
    required this.index,
    required this.onReOrderCallback,
    required this.onDragFinish,
    this.onDragCallback,
    this.onMergeCallback,
  }) : super(key: key);

  @override
  _BookShelfReorderGridAnimatedItemState createState() =>
      _BookShelfReorderGridAnimatedItemState();
}

class _BookShelfReorderGridAnimatedItemState
    extends State<BookShelfReorderGridAnimatedItem>
    with TickerProviderStateMixin {
  bool _isShouldIgnorePoint = false;
  bool _isMergeTarget = false;

  @override
  Widget build(BuildContext context) {
    var itemParentData = ((context as Element).renderObject?.parentData)
        as SliverGridParentData?;

    var itemData = BookShelfItemInheritedWidget.of(context)?.itemData;
    var listDataWidget = BookShelfListDataInheritedWidget.of(context);

    var transformX = 0.0;
    var transformY = 0.0;

    if (itemParentData == null ||
        itemData == null ||
        itemData.currentOffset.dx == -1 ||
        itemData.currentOffset.dy == -1) {
    } else {
      transformX =
          (itemParentData.crossAxisOffset ?? 0) - (itemData.currentOffset.dx);

      transformY =
          (itemParentData.layoutOffset ?? 0) - (itemData.currentOffset.dy);
    }

    var transformMatrix =
        Matrix4.translationValues(-transformX, -transformY, 0.0);

    if (transformX != 0 || transformY != 0) {
      _isShouldIgnorePoint = true;
    }

    _isMergeTarget = itemData?.isMergeTarget ?? false;

    return IgnorePointer(
      ignoring: _isShouldIgnorePoint,
      child: Container(
        child: BookShelfAnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: transformMatrix,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isMergeTarget ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
          onEnd: () {
            setState(() {
              _isShouldIgnorePoint = false;
            });
          },
          child: LayoutBuilder(
            builder: (BuildContext layoutContext, BoxConstraints constraints) {
              return Stack(
                children: [
                  Center(
                    child: buildDraggable(constraints, widget.index,
                        widget.child, listDataWidget, itemData),
                  ),
                  buildReorderDragTarget(
                      widget.index, listDataWidget, itemData),
                  Center(
                    child: buildItemFolderDragTarget(
                        widget.index, listDataWidget, itemData),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildDraggable(
      BoxConstraints constraints,
      int index,
      Widget childWidget,
      BookShelfListDataInheritedWidget? listDataWidget,
      ItemData? itemData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(builder: (context, constraints) {
        var itemWidget = Container(
          width: constraints.maxWidth,
          child: childWidget,
        );
        return BookShelfLongPressDraggable(
          data: itemData,
          feedback: IgnorePointer(
            ignoring: true,
            child: itemWidget,
          ),
          child: MetaData(child: itemWidget, behavior: HitTestBehavior.opaque),
          onDragStarted: () {
            listDataWidget?.currentOperateIndexList[0] = index;
            widget.onDragCallback?.call(index);
          },
          onDraggableCanceled: (velocity, offset) {},
          onDragCompleted: () {},
          onDragEnd: (detail) {
            widget.onDragFinish.call();
          },
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: itemWidget,
          ),
        );
      }),
    );
  }

  Widget buildReorderDragTarget(int currentItemIndex,
      BookShelfListDataInheritedWidget? listDataWidget, ItemData? itemData) {
    return Container(
      child: BookShelfDragTarget<ItemData>(
        delayAcceptDuration: Duration(milliseconds: 200),
        key: ValueKey(itemData?.renderObjectIndex),
        builder: (BuildContext context, List<ItemData?> acceptedCandidates,
                List<dynamic> rejectedCandidates) =>
            Container(),
        onDelayWillAccept: (ItemData? toAcceptItemData) {
          if (toAcceptItemData != null) {
            if (toAcceptItemData.renderObjectIndex !=
                itemData?.renderObjectIndex) {
              listDataWidget?.currentOperateIndexList[1] =
                  itemData?.renderObjectIndex ?? 0;

              widget.onReOrderCallback.call(itemData?.renderObjectIndex ?? 0,
                  toAcceptItemData.renderObjectIndex ?? 0);
            }
          }
          return toAcceptItemData != null;
        },
      ),
    );
  }

  Widget buildItemFolderDragTarget(int currentItemIndex,
      BookShelfListDataInheritedWidget? listDataWidget, ItemData? itemData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 37, vertical: 30),
      child: BookShelfDragTarget<ItemData>(
        delayAcceptDuration: Duration(seconds: 1),
        builder: (BuildContext context, List<ItemData?> acceptedCandidates,
            List<dynamic> rejectedCandidates) {
          return Container();
        },
        onDelayWillAccept: (ItemData? toAcceptItemData) {
          if (toAcceptItemData != null) {
            if (toAcceptItemData.renderObjectIndex !=
                itemData?.renderObjectIndex) {
              if (itemData?.itemIndex != null) {
                widget.onMergeCallback?.call(itemData!.itemIndex);
              }
            }
          }
          return toAcceptItemData != null;
        },
        onLeave: (leaveTargetData) {
          print('onLeave target is $leaveTargetData , current is $itemData');
          if (itemData?.isMergeTarget ?? false) {
            itemData?.toggleMergeTarget();
          }
        },
      ),
    );
  }
}
