import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'custom_carousel_scrollable.dart';


/// A [ScrollController] that provides additional capabilities for use with [CustomCarousel].
///
/// It adds item oriented features such as [selectedItem], [animateToItem], [jumpToItem],
/// [nextItem], and [previousItem]. Via [CustomCarouselScrollPosition], it also provides
/// support for [CustomCarousel.loop] functionality, and reasonable defaults for
/// `duration` and `curve` on scroll animations.
class CustomCarouselScrollController extends ScrollController {
  /// Creates a scroll controller for [CustomCarousel].
  ///
  /// [initialItem] defaults to 0 and must not be null.
  CustomCarouselScrollController({
    this.initialItem = 0,
  });

  @override
  CustomCarouselScrollPosition get position =>
      super.position as CustomCarouselScrollPosition;

  /// The item to show when first creating the scroll view.
  ///
  /// Defaults to 0 and must not be null.
  final int initialItem;

  /// The currently selected item index.
  ///
  /// There are circumstances that this [CustomCarouselScrollController] can't know
  /// the current item. Reading [selectedItem] will throw an [AssertionError] in
  /// the following cases:
  ///
  /// 1. No scroll view is currently using this [CustomCarouselScrollController].
  /// 2. More than one scroll views using the same [CustomCarouselScrollController].
  ///
  /// The [hasClients] property can be used to check if a scroll view is
  /// attached prior to accessing [selectedItem].
  int get selectedItem {
    assert(
      positions.isNotEmpty,
      'CustomCarouselScrollPosition.selectedItem cannot be accessed before a '
      'scroll view is built with it.',
    );
    assert(
      positions.length == 1,
      'The selectedItem property cannot be read when multiple scroll views are '
      'attached to the same CustomCarouselScrollPosition.',
    );
    return position.itemIndex;
  }

  /// Animates the controlled scroll view to the given item index.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> animateToItem(
    int itemIndex, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (!hasClients) return;
    return animateTo(
      itemIndex * position.itemExtent,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates the position from its current value to the given value.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// See [ScrollController.animateTo] for details.
  ///
  /// Unlike [ScrollController.animateTo], this method will default to using
  /// [Curves.easeInOutSine] for the `curve`, and a `duration` based on the
  /// distance to be traveled if none is provided.
  @override
  Future<void> animateTo(
    double offset, {
    Duration? duration,
    Curve? curve,
  }) {
    return position.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates the controlled scroll view to the next item.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> nextItem({
    Duration? duration,
    Curve? curve,
  }) {
    return animateToItem(
      selectedItem + 1,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates the controlled scroll view to the previous item.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> previousItem({
    Duration? duration,
    Curve? curve,
  }) {
    return animateToItem(
      selectedItem - 1,
      duration: duration,
      curve: curve,
    );
  }

  /// Changes which item index is centered in the controlled scroll view.
  ///
  /// Jumps the item index position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToItem(int itemIndex) {
    position.jumpTo(itemIndex * position.itemExtent);
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return CustomCarouselScrollPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}

class CustomCarouselScrollPosition extends ScrollPositionWithSingleContext
    implements FixedExtentMetrics {
  CustomCarouselScrollPosition({
    required super.physics,
    required super.context,
    required int initialItem,
    super.oldPosition,
  })  : assert(
          context is CustomCarouselScrollableState,
          'CustomCarouselScrollController can only be used with CustomCarouselScrollable',
        ),
        super(
          initialPixels: _getItemExtentFromScrollContext(context) * initialItem,
        );

  static double _getItemExtentFromScrollContext(ScrollContext context) {
    return (context as CustomCarouselScrollableState).itemExtent;
  }

  double get itemExtent => _getItemExtentFromScrollContext(context);

  double normalizePixels(double pixels) {
    final int itemCount = context.itemCount;
    if (itemCount == 0 || !context.loop) return pixels;
    final double range = itemExtent * itemCount;
    return (pixels + range) % range;
  }

  int normalizeItem(int index) {
    final int itemCount = context.itemCount;
    if (itemCount == 0 || !context.loop) return index;
    return (index + itemCount) % itemCount;
  }

  @override
  CustomCarouselScrollableState get context =>
      super.context as CustomCarouselScrollableState;

  @override
  double setPixels(double newPixels) =>
      super.setPixels(normalizePixels(newPixels));

  int getItemFromOffset(double offset) {
    return (offset.clamp(minScrollExtent, maxScrollExtent) / itemExtent)
        .round();
  }

  @override
  Future<void> animateTo(double to, {Duration? duration, Curve? curve}) {
    final int itemCount = context.itemCount;
    if (itemCount > 0 && context.loop) {
      // calculate the shortest direction to the target
      to = normalizePixels(to);
      final double from = normalizePixels(pixels);
      correctPixels(from);
      final double range = itemExtent * itemCount;
      if ((to - from).abs() > range / 2) to += to > from ? -range : range;
    }
    if (duration == null) {
      // calculate a reasonable default duration based on distance:
      final double delta = (pixels - to).abs();
      duration =
          Duration(milliseconds: (math.pow(delta, 0.6) * 5 + 150).round());
    }
    return super.animateTo(to,
        duration: duration, curve: curve ?? Curves.easeInOutSine);
  }

  @override
  int get itemIndex => normalizeItem(getItemFromOffset(pixels));

  @override
  FixedExtentMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    int? itemIndex,
    double? devicePixelRatio,
  }) {
    return FixedExtentMetrics(
      minScrollExtent: minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }
}