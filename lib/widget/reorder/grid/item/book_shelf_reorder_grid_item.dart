import 'package:flutter/material.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';

import '../book_shelf_animated_container.dart';

typedef ReOrderCallback = Function(int newIndex, int oldIndex);

class BookShelfReorderGridAnimatedItem extends StatefulWidget {
  final Widget child;
  final int index;
  final ReOrderCallback onWillAcceptCallback;
  final VoidCallback onAnimationEndCallback;

  const BookShelfReorderGridAnimatedItem(this.child, this.index,
      this.onWillAcceptCallback, this.onAnimationEndCallback,
      {Key? key})
      : super(key: key);

  @override
  _BookShelfReorderGridAnimatedItemState createState() =>
      _BookShelfReorderGridAnimatedItemState();
}

class _BookShelfReorderGridAnimatedItemState
    extends State<BookShelfReorderGridAnimatedItem>
    with TickerProviderStateMixin {
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
    BookShelfItemPositionInheritedWidget? posInheritedWidget =
        BookShelfItemPositionInheritedWidget.of(context);

    var posList = posInheritedWidget?.posList ?? [];
    var reOrderPosList = posInheritedWidget?.reOrderPosList ?? [];

    var transformX = reOrderPosList.isNotEmpty
        ? (reOrderPosList[widget.index].dx) - (posList[widget.index].dx)
        : 0.0;
    var transformY = reOrderPosList.isNotEmpty
        ? (reOrderPosList[widget.index].dy) - (posList[widget.index].dy)
        : 0.0;

    var transformMatrix = Matrix4.translationValues(
        transformX.toDouble(), transformY.toDouble(), 0.0);

    print('$transformX _ $transformY');

    return Transform.translate(
      offset: Offset(0, 0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          reOrderPosList.clear();
          reOrderPosList.addAll(posList);
          return Stack(
            children: [
              buildDraggable(
                  constraints, widget.index, widget.child, posInheritedWidget),
              buildDragTarget(widget.index, posInheritedWidget),
            ],
          );
        },
      ),
    );

    return BookShelfAnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform: transformMatrix,
      onAnimationEndCallback: (animationController) {
        // widget.onAnimationEndCallback.call();
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          reOrderPosList.clear();
          reOrderPosList.addAll(posList);
          return Stack(
            children: [
              buildDraggable(
                  constraints, widget.index, widget.child, posInheritedWidget),
              buildDragTarget(widget.index, posInheritedWidget),
            ],
          );
        },
      ),
    );
  }

  Widget buildDraggable(
      BoxConstraints constraints,
      int index,
      Widget childWidget,
      BookShelfItemPositionInheritedWidget? positionInheritedWidget) {
    var itemWidget = Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: childWidget,
    );
    var feedback = Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: childWidget,
    );

    return LongPressDraggable(
      data: index,
      feedback: itemWidget,
      child: MetaData(child: itemWidget, behavior: HitTestBehavior.opaque),
      onDragStarted: () {
        print('onDragStarted');
      },
      onDraggableCanceled: (velocity, offset) {
        print('onDraggableCanceled');
      },
      onDragCompleted: () {
        print('onDragCompleted');
      },
      onDragEnd: (detail) {
        print('onDragEnd');
      },
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: itemWidget,
      ),
    );
  }

  Widget buildDragTarget(int currentItemIndex,
      BookShelfItemPositionInheritedWidget? positionInheritedWidget) {
    return DragTarget<int>(
      builder: (BuildContext context, List<int?> acceptedCandidates,
              List<dynamic> rejectedCandidates) =>
          Container(),
      onWillAccept: (int? toAcceptItemIndex) {
        if (toAcceptItemIndex != null &&
            toAcceptItemIndex != currentItemIndex) {
          var reOrderList = positionInheritedWidget?.reOrderPosList;
          if (reOrderList != null && reOrderList.isNotEmpty) {
            print('reOrderList before is $reOrderList');

            reOrderList.insert(
                toAcceptItemIndex, reOrderList.removeAt(currentItemIndex));

            print('reOrderList after is $reOrderList');

            widget.onWillAcceptCallback
                .call(toAcceptItemIndex, currentItemIndex);

            // setState(() {});
          }
        }
        return toAcceptItemIndex != null;
      },
      onAccept: (int accepted) {
        print('onAccept');
      },
      onLeave: (Object? leaving) {
        print('onLeave');
      },
    );
  }
}
