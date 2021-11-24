import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';
import 'package:test_project/scroll/sliver/power_sliver.dart';

class PowerListView extends ListView {
  PowerListView({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    this.layoutManager,
  }) : super(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            itemExtent: itemExtent,
            prototypeItem: prototypeItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            cacheExtent: cacheExtent,
            children: children,
            semanticChildCount: semanticChildCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  PowerListView.builder({
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
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
    this.layoutManager,
  }) : super.builder(
            key: key,
            scrollDirection: scrollDirection,
            reverse: reverse,
            controller: controller,
            primary: primary,
            physics: physics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            itemExtent: itemExtent,
            prototypeItem: prototypeItem,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            cacheExtent: cacheExtent,
            semanticChildCount: semanticChildCount,
            dragStartBehavior: dragStartBehavior,
            keyboardDismissBehavior: keyboardDismissBehavior,
            restorationId: restorationId,
            clipBehavior: clipBehavior);

  final LayoutManager? layoutManager;

  @override
  Widget buildChildLayout(BuildContext context) {
    return PowerSliverList(
      delegate: childrenDelegate,
      layoutManager: layoutManager ?? PowerListLinearLayoutManager(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var gestureNotify = PowerListGestureDataNotify();
    var widget = PowerListDataInheritedWidget(
      indexNotify: PowerListIndexDataNotify(),
      gestureNotify: gestureNotify,
      child: Listener(
        onPointerDown: (PointerDownEvent downEvent) {
          gestureNotify.setSignalEvent(downEvent);
        },
        onPointerMove: (PointerMoveEvent moveEvent) {
          var page = (controller?.offset ?? 0) ~/
              (controller?.position.viewportDimension ?? 0);

          var dx = page * (controller?.position.viewportDimension ?? 0) +
              ((controller?.position.viewportDimension ?? 0) -
                  (moveEvent.position.dx));

          controller?.animateTo(dx,
              duration: Duration(seconds: 1), curve: Curves.linear);

          gestureNotify.setSignalEvent(moveEvent);
        },
        onPointerUp: (PointerUpEvent upEvent) {
          gestureNotify.setSignalEvent(upEvent);
        },
        onPointerCancel: (PointerCancelEvent cancelEvent) {
          gestureNotify.setSignalEvent(cancelEvent);
        },
        child: super.build(context),
      ),
    );

    return widget;
  }
}
