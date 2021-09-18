import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/layout/recycler_view_layout_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/sliver/recycler_sliver.dart';

class RecyclerViewItemOffsetWidget extends Padding {
  final LayoutManager? layoutManager;

  RecyclerViewItemOffsetWidget({
    Key? key,
    required EdgeInsetsGeometry padding,
    this.layoutManager,
    Widget? child,
  }) : super(key: key, padding: padding, child: child);
}

class RecyclerViewItemTransformWidget extends SingleChildRenderObjectWidget {
  final LayoutManager? layoutManager;

  const RecyclerViewItemTransformWidget({
    Key? key,
    this.layoutManager,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  RecyclerViewItemRenderTransform createRenderObject(BuildContext context) {
    return RecyclerViewItemRenderTransform(
      layoutManager: layoutManager,
      alignment: AlignmentDirectional.center,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RecyclerViewItemRenderTransform renderObject) {
    renderObject..textDirection = Directionality.maybeOf(context);
  }
}

class RecyclerViewItemRenderTransform extends RenderProxyBox {
  LayoutManager? layoutManager;

  /// Creates a render object that transforms its child.
  ///
  /// The [transform] argument must not be null.
  RecyclerViewItemRenderTransform({
    required LayoutManager? layoutManager,
    Offset? origin,
    AlignmentGeometry? alignment,
    TextDirection? textDirection,
    this.transformHitTests = true,
    RenderBox? child,
  }) : super(child) {
    this.layoutManager = layoutManager;
    this.alignment = alignment;
    this.textDirection = textDirection;
    this.origin = origin;
  }

  /// The origin of the coordinate system (relative to the upper left corner of
  /// this render object) in which to apply the matrix.
  ///
  /// Setting an origin is equivalent to conjugating the transform matrix by a
  /// translation. This property is provided just for convenience.
  Offset? get origin => _origin;
  Offset? _origin;

  set origin(Offset? value) {
    if (_origin == value) return;
    _origin = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// The alignment of the origin, relative to the size of the box.
  ///
  /// This is equivalent to setting an origin based on the size of the box.
  /// If it is specified at the same time as an offset, both are applied.
  ///
  /// An [AlignmentDirectional.centerStart] value is the same as an [Alignment]
  /// whose [Alignment.x] value is `-1.0` if [textDirection] is
  /// [TextDirection.ltr], and `1.0` if [textDirection] is [TextDirection.rtl].
  /// Similarly [AlignmentDirectional.centerEnd] is the same as an [Alignment]
  /// whose [Alignment.x] value is `1.0` if [textDirection] is
  /// [TextDirection.ltr], and `-1.0` if [textDirection] is [TextDirection.rtl].
  AlignmentGeometry? get alignment => _alignment;
  AlignmentGeometry? _alignment;

  set alignment(AlignmentGeometry? value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// The text direction with which to resolve [alignment].
  ///
  /// This may be changed to null, but only after [alignment] has been changed
  /// to a value that does not depend on the direction.
  TextDirection? get textDirection => _textDirection;
  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// When set to true, hit tests are performed based on the position of the
  /// child as it is painted. When set to false, hit tests are performed
  /// ignoring the transformation.
  ///
  /// [applyPaintTransform], and therefore [localToGlobal] and [globalToLocal],
  /// always honor the transformation, regardless of the value of this property.
  bool transformHitTests;

  // Note the lack of a getter for transform because Matrix4 is not immutable
  Matrix4? _transform = Matrix4.identity();

  /// The matrix to transform the child by during painting.
  set transform(Matrix4 value) {
    assert(value != null);
    if (_transform == value) return;
    _transform = Matrix4.copy(value);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Sets the transform to the identity matrix.
  void setIdentity() {
    _transform!.setIdentity();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the x axis into the transform.
  void rotateX(double radians) {
    _transform!.rotateX(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the y axis into the transform.
  void rotateY(double radians) {
    _transform!.rotateY(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a rotation about the z axis into the transform.
  void rotateZ(double radians) {
    _transform!.rotateZ(radians);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a translation by (x, y, z) into the transform.
  void translate(double x, [double y = 0.0, double z = 0.0]) {
    _transform!.translate(x, y, z);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// Concatenates a scale into the transform.
  void scale(double x, [double? y, double? z]) {
    _transform!.scale(x, y, z);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Matrix4? get _effectiveTransform {
    final Alignment? resolvedAlignment = alignment?.resolve(textDirection);
    if (_origin == null && resolvedAlignment == null) return _transform;
    final Matrix4 result = Matrix4.identity();
    if (_origin != null) result.translate(_origin!.dx, _origin!.dy);
    Offset? translation;
    if (resolvedAlignment != null) {
      translation = resolvedAlignment.alongSize(size);
      result.translate(translation.dx, translation.dy);
    }
    result.multiply(_transform!);
    if (resolvedAlignment != null)
      result.translate(-translation!.dx, -translation.dy);
    if (_origin != null) result.translate(-_origin!.dx, -_origin!.dy);
    return result;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // RenderTransform objects don't check if they are
    // themselves hit, because it's confusing to think about
    // how the untransformed size and the child's transformed
    // position interact.
    return hitTestChildren(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    assert(!transformHitTests || _effectiveTransform != null);
    return result.addWithPaintTransform(
      transform: transformHitTests ? _effectiveTransform : null,
      position: position,
      hitTest: (BoxHitTestResult result, Offset? position) {
        return super.hitTestChildren(result, position: position!);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? itemChild = child;
    if (itemChild != null) {
      _transform = getItemTransform(itemChild);
    }

    if (child != null) {
      final Matrix4 transform = _effectiveTransform!;
      final Offset? childOffset = MatrixUtils.getAsTranslation(transform);
      if (childOffset == null) {
        layer = context.pushTransform(
          needsCompositing,
          offset,
          transform,
          super.paint,
          oldLayer: layer as TransformLayer?,
        );
      } else {
        super.paint(context, offset + childOffset);
        layer = null;
      }
    }
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_effectiveTransform!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(TransformProperty('transform matrix', _transform));
    properties.add(DiagnosticsProperty<Offset>('origin', origin));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('transformHitTests', transformHitTests));
  }

  Matrix4? getItemTransform(RenderBox child) {
    if (layoutManager == null ||
        layoutManager!.onPaintTransformCallback == null) {
      return Matrix4.identity();
    }

    RecyclerViewSliverMultiBoxAdaptorParentData? parentData;

    RenderBox currentChild = child;
    while (currentChild.parent != null) {
      if (!(currentChild.parentData
          is RecyclerViewSliverMultiBoxAdaptorParentData)) {
        currentChild = currentChild.parent as RenderBox;
        continue;
      }

      parentData = currentChild.parentData
          as RecyclerViewSliverMultiBoxAdaptorParentData;
      break;
    }

    if (parentData == null) {
      return Matrix4.identity();
    }

    assert(parentData.index != null);
    parentData.itemState?.contentRangeRect=Rect.fromLTWH(0, 0, size.width, size.height);
    return layoutManager!.onPaintTransform(
        parentData.index ?? 0, parentData.itemState ?? ItemDecorationState());
  }
}
