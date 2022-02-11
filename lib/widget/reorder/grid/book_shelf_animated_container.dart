import 'package:flutter/cupertino.dart';

typedef BookShelfOnEndCallback = Function(
    AnimationController containerController);

class BookShelfAnimatedContainer extends AnimatedContainer {
  final BookShelfOnEndCallback? onAnimationEndCallback;

  BookShelfAnimatedContainer({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Widget? child,
    Clip clipBehavior = Clip.none,
    Curve curve = Curves.linear,
    required Duration duration,
    this.onAnimationEndCallback,
  }) : super(
            key: key,
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            child: child,
            clipBehavior: clipBehavior,
            curve: curve,
            duration: duration);

  @override
  AnimatedWidgetBaseState<BookShelfAnimatedContainer> createState() {
    return _BookShelfAnimatedContainerState();
  }
}

class _BookShelfAnimatedContainerState
    extends AnimatedWidgetBaseState<BookShelfAnimatedContainer> {
  AlignmentGeometryTween? _alignment;
  EdgeInsetsGeometryTween? _padding;
  DecorationTween? _decoration;
  DecorationTween? _foregroundDecoration;
  BoxConstraintsTween? _constraints;
  EdgeInsetsGeometryTween? _margin;
  Matrix4Tween? _transform;
  AlignmentGeometryTween? _transformAlignment;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
            _alignment,
            widget.alignment,
            (dynamic value) =>
                AlignmentGeometryTween(begin: value as AlignmentGeometry))
        as AlignmentGeometryTween?;
    _padding = visitor(
            _padding,
            widget.padding,
            (dynamic value) =>
                EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry))
        as EdgeInsetsGeometryTween?;
    _decoration = visitor(_decoration, widget.decoration,
            (dynamic value) => DecorationTween(begin: value as Decoration))
        as DecorationTween?;
    _foregroundDecoration = visitor(
            _foregroundDecoration,
            widget.foregroundDecoration,
            (dynamic value) => DecorationTween(begin: value as Decoration))
        as DecorationTween?;
    _constraints = visitor(
            _constraints,
            widget.constraints,
            (dynamic value) =>
                BoxConstraintsTween(begin: value as BoxConstraints))
        as BoxConstraintsTween?;
    _margin = visitor(
            _margin,
            widget.margin,
            (dynamic value) =>
                EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry))
        as EdgeInsetsGeometryTween?;
    _transform = visitor(_transform, widget.transform,
            (dynamic value) => Matrix4Tween(begin: value as Matrix4))
        as Matrix4Tween?;
    _transformAlignment = visitor(
            _transformAlignment,
            widget.transformAlignment,
            (dynamic value) =>
                AlignmentGeometryTween(begin: value as AlignmentGeometry))
        as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;
    return Container(
      alignment: _alignment?.evaluate(animation),
      padding: _padding?.evaluate(animation),
      decoration: _decoration?.evaluate(animation),
      foregroundDecoration: _foregroundDecoration?.evaluate(animation),
      constraints: _constraints?.evaluate(animation),
      margin: _margin?.evaluate(animation),
      transform: _transform?.evaluate(animation),
      transformAlignment: _transformAlignment?.evaluate(animation),
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.completed:
          widget.onAnimationEndCallback?.call(controller);
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
      }
    });
  }
}
