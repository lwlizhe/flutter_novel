import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PowerListViewPort extends Viewport {
  PowerListViewPort({
    Key? key,
    AxisDirection axisDirection = AxisDirection.down,
    AxisDirection? crossAxisDirection,
    double anchor = 0.0,
    required ViewportOffset offset,
    Key? center,
    double? cacheExtent,
    CacheExtentStyle cacheExtentStyle = CacheExtentStyle.pixel,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> slivers = const <Widget>[],
  }) : super(
            key: key,
            axisDirection: axisDirection,
            crossAxisDirection: crossAxisDirection,
            anchor: anchor,
            offset: offset,
            center: center,
            cacheExtent: cacheExtent,
            cacheExtentStyle: cacheExtentStyle,
            clipBehavior: clipBehavior,
            slivers: slivers);

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return PowerListRenderViewPort(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
    );
  }
}

class PowerListRenderViewPort extends RenderViewport {
  PowerListRenderViewPort({
    AxisDirection axisDirection = AxisDirection.down,
    required AxisDirection crossAxisDirection,
    required ViewportOffset offset,
    double anchor = 0.0,
    List<RenderSliver>? children,
    RenderSliver? center,
    double? cacheExtent,
    CacheExtentStyle cacheExtentStyle = CacheExtentStyle.pixel,
    Clip clipBehavior = Clip.hardEdge,
  }) : super(
            axisDirection: axisDirection,
            crossAxisDirection: crossAxisDirection,
            offset: offset,
            anchor: anchor,
            children: children,
            center: center,
            cacheExtent: cacheExtent,
            cacheExtentStyle: cacheExtentStyle,
            clipBehavior: clipBehavior);

  @override
  bool get isRepaintBoundary => false;
}
