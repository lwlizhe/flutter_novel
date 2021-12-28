import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';
import 'package:test_project/scroll/sliver/power_scrollable.dart';
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
  })  : assert(
            (!(controller is PowerListScrollController && controller.isLoop)) ||
                (itemCount != null && itemCount > 0),
            'if isLoop of controller is true , then the itemCount must be greater than 0 '),
        super.builder(
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
            itemBuilder: (context, index) {
              bool isLoop = (controller is PowerListScrollController &&
                  controller.isLoop);
              return itemBuilder.call(
                  context, isLoop ? index % itemCount! : index);
            },
            itemCount:
                (controller is PowerListScrollController && controller.isLoop)
                    ? itemCount! + 1
                    : itemCount,
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
    final List<Widget> slivers = buildSlivers(context);
    final AxisDirection axisDirection = getDirection(context);
    var gestureNotify = PowerListGestureDataNotify();

    final ScrollController? scrollController =
        primary ? PrimaryScrollController.of(context) : controller;

    final PowerScrollable scrollable = PowerScrollable(
      dragStartBehavior: dragStartBehavior,
      axisDirection: axisDirection,
      controller: scrollController,
      physics: physics,
      scrollBehavior: scrollBehavior,
      semanticChildCount: semanticChildCount,
      restorationId: restorationId,
      viewportBuilder: (BuildContext context, ViewportOffset offset) {
        return buildViewport(context, offset, axisDirection, slivers);
      },
    );
    final Widget scrollableResult = primary && scrollController != null
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    final Widget itemResult = PowerListDataInheritedWidget(
      indexNotify: PowerListIndexDataNotify(),
      gestureNotify: gestureNotify,
      child: Listener(
        onPointerDown: (PointerDownEvent downEvent) {
          gestureNotify.setSignalEvent(downEvent);
        },
        onPointerMove: (PointerMoveEvent moveEvent) {
          gestureNotify.setSignalEvent(moveEvent);
        },
        onPointerUp: (PointerUpEvent upEvent) {
          gestureNotify.setSignalEvent(upEvent);
        },
        onPointerCancel: (PointerCancelEvent cancelEvent) {
          gestureNotify.setSignalEvent(cancelEvent);
        },
        child: scrollableResult,
      ),
    );

    if (keyboardDismissBehavior == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: itemResult,
        onNotification: (ScrollUpdateNotification notification) {
          final FocusScopeNode focusScope = FocusScope.of(context);
          if (notification.dragDetails != null && focusScope.hasFocus) {
            focusScope.unfocus();
          }
          return false;
        },
      );
    } else {
      return itemResult;
    }
  }
}
