import 'package:flutter/material.dart';


/// A [Scrollable] that exposes [itemExtent], [itemCount], and [loop] for use by [CustomCarouselScrollPosition].
class CustomCarouselScrollable extends Scrollable {
  const CustomCarouselScrollable({
    super.key,
    super.controller,
    super.physics,
    required this.itemExtent,
    required super.viewportBuilder,
    super.restorationId,
    super.scrollBehavior,
    super.axisDirection,
    super.excludeFromSemantics,
    this.loop = false,
    required this.itemCount,
  }) : super(semanticChildCount: itemCount);

  final double itemExtent;
  final int itemCount;
  final bool loop;

  @override
  CustomCarouselScrollableState createState() =>
      CustomCarouselScrollableState();
}

/// State object for a [CustomCarouselScrollable]. Exposes [itemExtent], [itemCount], and [loop].
class CustomCarouselScrollableState extends ScrollableState {
  @override
  CustomCarouselScrollable get widget =>
      super.widget as CustomCarouselScrollable;

  double get itemExtent => widget.itemExtent;
  bool get loop => widget.loop;
  int get itemCount => widget.itemCount;
}
