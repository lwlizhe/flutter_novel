import 'package:flutter/rendering.dart';

class PowerSliverListParentData extends SliverMultiBoxAdaptorParentData {
  /// The position of the child relative to the parent.
  ///
  /// This is the distance from the top left visible corner of the parent to the
  /// top left visible corner of the sliver.
  Offset paintOffset = Offset.zero;

  /// Apply the [paintOffset] to the given [transform].
  ///
  /// Used to implement [RenderObject.applyPaintTransform] by slivers that use
  /// [SliverPhysicalParentData].
  void applyPaintTransform(Matrix4 transform) {
    // Hit test logic relies on this always providing an invertible matrix.
    transform.translate(paintOffset.dx, paintOffset.dy);
  }

  @override
  String toString() => super.toString() + 'paintOffset=$paintOffset';
}
