import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListTransform extends Transform {
  ListTransform({
    Key? key,
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    Widget? child,
  }) : super(
            key: key,
            transform: transform,
            origin: origin,
            alignment: alignment,
            transformHitTests: transformHitTests,
            child: child);

  @override
  RenderTransform createRenderObject(BuildContext context) {
    return ListRenderTransform(
      transform: transform,
      origin: origin,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      transformHitTests: transformHitTests,
    );
  }
}

class ListRenderTransform extends RenderTransform {
  ListRenderTransform({
    required Matrix4 transform,
    Offset? origin,
    AlignmentGeometry? alignment,
    bool transformHitTests = true,
    TextDirection? textDirection,
    RenderBox? child,
  }) : super(
            transform: transform,
            origin: origin,
            alignment: alignment,
            transformHitTests: transformHitTests,
            textDirection: textDirection,
            child: child);


}
