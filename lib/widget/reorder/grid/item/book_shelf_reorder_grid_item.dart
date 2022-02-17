import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/widget/reorder/darg/book_shelf_drag_target.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_animated_container.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef ReOrderCallback = Function(int toIndex, int fromIndex);

class BookShelfReorderGridAnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  final ReOrderCallback onWillAcceptCallback;
  final VoidCallback onDragFinish;
  final VoidCallback onDragStart;

  const BookShelfReorderGridAnimatedItem({
    Key? key,
    required this.child,
    required this.index,
    required this.onWillAcceptCallback,
    required this.onDragFinish,
    required this.onDragStart,
  }) : super(key: key);

  @override
  _BookShelfReorderGridAnimatedItemState createState() =>
      _BookShelfReorderGridAnimatedItemState();
}

class _BookShelfReorderGridAnimatedItemState
    extends State<BookShelfReorderGridAnimatedItem>
    with TickerProviderStateMixin {
  bool _isShouldIgnorePoint = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BookShelfReorderGridAnimatedItem oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

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

    return IgnorePointer(
      ignoring: _isShouldIgnorePoint,
      child: Container(
        child: BookShelfAnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: transformMatrix,
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
            widget.onDragStart.call();
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

              widget.onWillAcceptCallback.call(itemData?.renderObjectIndex ?? 0,
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
              Fluttertoast.showToast(msg: '移动到Item上不动一秒，视为创建文件夹合并书籍');
            }
          }
          return toAcceptItemData != null;
        },
      ),
    );
  }
}
