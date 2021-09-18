import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/viewport/render/over_scroll_view_port.dart';

class OverScrollViewPort extends MultiChildRenderObjectWidget {
  OverScrollViewPort({
    Key? key,
    this.axisDirection = AxisDirection.down,
    this.crossAxisDirection,
    this.anchor = 0.0,
    required this.offset,
    this.center,
    this.cacheExtent,
    this.cacheExtentStyle = CacheExtentStyle.pixel,
    this.clipBehavior = Clip.hardEdge,
    List<Widget> slivers = const <Widget>[],
  }) :        super(key: key, children: slivers);

  /// The direction in which the [offset]'s [ViewportOffset.pixels] increases.
  ///
  /// For example, if the [axisDirection] is [AxisDirection.down], a scroll
  /// offset of zero is at the top of the viewport and increases towards the
  /// bottom of the viewport.
  final AxisDirection axisDirection;

  /// The direction in which child should be laid out in the cross axis.
  ///
  /// If the [axisDirection] is [AxisDirection.down] or [AxisDirection.up], this
  /// property defaults to [AxisDirection.left] if the ambient [Directionality]
  /// is [TextDirection.rtl] and [AxisDirection.right] if the ambient
  /// [Directionality] is [TextDirection.ltr].
  ///
  /// If the [axisDirection] is [AxisDirection.left] or [AxisDirection.right],
  /// this property defaults to [AxisDirection.down].
  final AxisDirection? crossAxisDirection;

  /// The relative position of the zero scroll offset.
  ///
  /// For example, if [anchor] is 0.5 and the [axisDirection] is
  /// [AxisDirection.down] or [AxisDirection.up], then the zero scroll offset is
  /// vertically centered within the viewport. If the [anchor] is 1.0, and the
  /// [axisDirection] is [AxisDirection.right], then the zero scroll offset is
  /// on the left edge of the viewport.
  final double anchor;

  /// Which part of the content inside the viewport should be visible.
  ///
  /// The [ViewportOffset.pixels] value determines the scroll offset that the
  /// viewport uses to select which part of its content to display. As the user
  /// scrolls the viewport, this value changes, which changes the content that
  /// is displayed.
  ///
  /// Typically a [ScrollPosition].
  final ViewportOffset offset;

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [axisDirection] relative to
  /// the [center]. Children before [center] will be placed in the opposite of
  /// the [axisDirection] relative to the [center].
  ///
  /// The [center] must be the key of a child of the viewport.
  final Key? center;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtent}
  ///
  /// See also:
  ///
  ///  * [cacheExtentStyle], which controls the units of the [cacheExtent].
  final double? cacheExtent;

  /// {@macro flutter.rendering.RenderViewportBase.cacheExtentStyle}
  final CacheExtentStyle cacheExtentStyle;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// Given a [BuildContext] and an [AxisDirection], determine the correct cross
  /// axis direction.
  ///
  /// This depends on the [Directionality] if the `axisDirection` is vertical;
  /// otherwise, the default cross axis direction is downwards.
  static AxisDirection getDefaultCrossAxisDirection(BuildContext context, AxisDirection axisDirection) {
    assert(axisDirection != null);
    switch (axisDirection) {
      case AxisDirection.up:
        assert(debugCheckHasDirectionality(
          context,
          why: 'to determine the cross-axis direction when the viewport has an \'up\' axisDirection',
          alternative: 'Alternatively, consider specifying the \'crossAxisDirection\' argument on the Viewport.',
        ));
        return textDirectionToAxisDirection(Directionality.of(context));
      case AxisDirection.right:
        return AxisDirection.down;
      case AxisDirection.down:
        assert(debugCheckHasDirectionality(
          context,
          why: 'to determine the cross-axis direction when the viewport has a \'down\' axisDirection',
          alternative: 'Alternatively, consider specifying the \'crossAxisDirection\' argument on the Viewport.',
        ));
        return textDirectionToAxisDirection(Directionality.of(context));
      case AxisDirection.left:
        return AxisDirection.down;
    }
  }

  @override
  OverScrollRenderViewPort createRenderObject(BuildContext context) {
    return OverScrollRenderViewPort(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ?? Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, OverScrollRenderViewPort renderObject) {
    renderObject
      ..axisDirection = axisDirection
      ..crossAxisDirection = crossAxisDirection ?? Viewport.getDefaultCrossAxisDirection(context, axisDirection)
      ..anchor = anchor
      ..offset = offset
      ..cacheExtent = cacheExtent
      ..cacheExtentStyle = cacheExtentStyle
      ..clipBehavior = clipBehavior;
  }

  @override
  _ViewportElement createElement() => _ViewportElement(this);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AxisDirection>('axisDirection', axisDirection));
    properties.add(EnumProperty<AxisDirection>('crossAxisDirection', crossAxisDirection, defaultValue: null));
    properties.add(DoubleProperty('anchor', anchor));
    properties.add(DiagnosticsProperty<ViewportOffset>('offset', offset));
    if (center != null) {
      properties.add(DiagnosticsProperty<Key>('center', center));
    } else if (children.isNotEmpty && children.first.key != null) {
      properties.add(DiagnosticsProperty<Key>('center', children.first.key, tooltip: 'implicit'));
    }
    properties.add(DiagnosticsProperty<double>('cacheExtent', cacheExtent));
    properties.add(DiagnosticsProperty<CacheExtentStyle>('cacheExtentStyle', cacheExtentStyle));
  }

}

class _ViewportElement extends MultiChildRenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  _ViewportElement(OverScrollViewPort widget) : super(widget);

  @override
  OverScrollViewPort get widget => super.widget as OverScrollViewPort;

  @override
  OverScrollRenderViewPort get renderObject => super.renderObject as OverScrollRenderViewPort;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _updateCenter();
  }

  @override
  void update(MultiChildRenderObjectWidget newWidget) {
    super.update(newWidget);
    _updateCenter();
  }

  void _updateCenter() {
    // TODO(ianh): cache the keys to make this faster
    if (widget.center != null) {
      renderObject.center = children.singleWhere(
            (Element element) => element.widget.key == widget.center,
      ).renderObject as RenderSliver?;
    } else if (children.isNotEmpty) {
      renderObject.center = children.first.renderObject as RenderSliver?;
    } else {
      renderObject.center = null;
    }
  }

  @override
  void debugVisitOnstageChildren(ElementVisitor visitor) {
    children.where((Element e) {
      final RenderSliver renderSliver = e.renderObject! as RenderSliver;
      return renderSliver.geometry!.visible;
    }).forEach(visitor);
  }
}


class OverScrollShrinkWrappingViewport extends ShrinkWrappingViewport {
  OverScrollShrinkWrappingViewport({
    Key? key,
    AxisDirection axisDirection = AxisDirection.down,
    AxisDirection? crossAxisDirection,
    required ViewportOffset offset,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> slivers = const <Widget>[],
  }) : super(
            key: key,
            axisDirection: axisDirection,
            crossAxisDirection: crossAxisDirection,
            offset: offset,
            clipBehavior: clipBehavior,
            slivers: slivers);
}
