import 'package:flutter/material.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';

import '../book_shelf_animated_container.dart';

typedef ReOrderCallback = Function(int toIndex, int fromIndex);

class BookShelfReorderGridAnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  final ReOrderCallback onWillAcceptCallback;
  final VoidCallback onDragFinish;

  const BookShelfReorderGridAnimatedItem(
      this.child, this.index, this.onWillAcceptCallback, this.onDragFinish,
      {Key? key})
      : super(key: key);

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
    print('build');

    var itemDataWidget = BookShelfItemInheritedWidget.of(context)?.itemData;
    var listDataWidget = BookShelfListDataInheritedWidget.of(context);

    var transformX = itemDataWidget?.transformOffset.dx ?? 0;

    var transformY = itemDataWidget?.transformOffset.dy ?? 0;

    var transformMatrix =
        Matrix4.translationValues(-transformX, -transformY, 0.0);

    if (transformX != 0 || transformY != 0) {
      _isShouldIgnorePoint = true;
    }

    return IgnorePointer(
      ignoring: _isShouldIgnorePoint,
      child: BookShelfAnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: transformMatrix,
        onEnd: () {
          itemDataWidget?.transformOffset = Offset.zero;
          setState(() {
            _isShouldIgnorePoint = false;
          });
        },
        child: LayoutBuilder(
          builder: (BuildContext layoutContext, BoxConstraints constraints) {
            return Stack(
              children: [
                buildDraggable(
                    constraints, widget.index, widget.child, listDataWidget),
                buildDragTarget(widget.index, listDataWidget),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildDraggable(
      BoxConstraints constraints,
      int index,
      Widget childWidget,
      BookShelfListDataInheritedWidget? positionInheritedWidget) {
    var itemWidget = Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: childWidget,
    );

    return LongPressDraggable(
      data: index,
      feedback: itemWidget,
      child: MetaData(child: itemWidget, behavior: HitTestBehavior.opaque),
      onDragStarted: () {
        positionInheritedWidget?.currentOperateIndexList[0] = index;
      },
      onDraggableCanceled: (velocity, offset) {},
      onDragCompleted: () {},
      onDragEnd: (detail) {
        widget.onDragFinish();
      },
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: itemWidget,
      ),
    );
  }

  Widget buildDragTarget(
      int currentItemIndex, BookShelfListDataInheritedWidget? listDataWidget) {
    var currentItemList = listDataWidget?.currentItemValueIndexList ?? [];

    return DragTarget<int>(
      builder: (BuildContext context, List<int?> acceptedCandidates,
              List<dynamic> rejectedCandidates) =>
          Container(),
      onWillAccept: (int? toAcceptItemIndex) {
        if (toAcceptItemIndex != null) {
          var realToAcceptItemIndex =
              currentItemList.indexOf(toAcceptItemIndex);

          var realCurrentItemIndex = currentItemList.indexOf(currentItemIndex);

          if (realToAcceptItemIndex != realCurrentItemIndex) {
            listDataWidget?.currentOperateIndexList[1] = realCurrentItemIndex;

            widget.onWillAcceptCallback
                .call(realCurrentItemIndex, realToAcceptItemIndex);
          }
        }
        return toAcceptItemIndex != null;
      },
    );
  }
}
