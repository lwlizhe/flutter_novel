import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'custom_carousel_scroll_controller.dart';
import 'custom_carousel_scroll_physics.dart';
import 'custom_carousel_scrollable.dart';

class CustomCarousel extends StatefulWidget {
  static EffectsBuilder effectsBuilderFromAnimate({
    required List<Effect> effects,
  }) {
    return (_, scrollRatio, constraints, child) => Animate(
          effects: effects,
          value: (scrollRatio + 1) / 2,
          autoPlay: false,
          child: child,
        );
  }

  const CustomCarousel({
    required this.effectsBuilder,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.physics,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.excludeFromSemantics = false,
    this.restorationId,
    this.scrollBehavior,
    this.onSelectedItemChanged,
    this.onSettledItemChanged,
    this.tapToSelect = true,
    this.itemCountBefore,
    this.itemCountAfter,
    this.scrollSpeed = 1,
    this.depthOrder = DepthOrder.forward,
    this.loop = false,
    this.alignment,
  }) : assert(
          itemCount > (itemCountBefore ?? 0) + (itemCountAfter ?? 0),
          'The total number of items must be greater than itemCountBefore + itemCountAfter.',
        );

  /// Indicates the axis for scroll interactions (ex. swiping, scroll wheel).
  /// Note that this does not affect the visual presentation of the scrolling
  /// (which are controlled via [effectsBuilder]), just the direction for user inputs.
  final Axis scrollDirection;

  /// Reverses the direction of scrolling interactions. For example if [scrollDirection] is [Axis.horizontal]
  /// setting [reverse] to `true` will cause positive scrolling to be left to right, instead of
  /// right to left.
  final bool reverse;

  /// A [CustomCarouselScrollController] instance that can be used to control
  /// the position to which this scroll view is scrolled. If none is provided,
  /// a new [CustomCarouselScrollController] is implicitly created.
  ///
  /// [CustomCarouselScrollController] offers a number of capabilities that are
  /// specific to [CustomCarousel] widgets, such as:
  /// - the ability to read the current selected item index via [CustomCarouselScrollController.selectedItem]
  /// - providing item-oriented methods, such as [CustomCarouselScrollController.animateToItem] and [CustomCarouselScrollController.jumpToItem]
  /// - logic to support [loop] functionality
  /// - smart defaults for `duration` and `curve` parameters of [CustomCarouselScrollController.animateTo]
  /// - support for [CustomCarouselScrollPhysics]
  ///
  /// See also:
  /// - [onSelectedItemChanged]
  /// - [onSettledItemChanged]
  final CustomCarouselScrollController? controller;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  ///
  /// Defaults to using [CustomCarouselScrollPhysics], which provides snap-to-item
  /// behavior.
  final ScrollPhysics? physics;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addRepaintBoundaries}}
  ///
  /// Repaint boundaries are added to children prior to calling [effectsBuilder].
  final bool addRepaintBoundaries;

  /// {@macro flutter.widgets.SliverChildBuilderDelegate.addSemanticIndexes}
  final bool addSemanticIndexes;

  /// {@macro flutter.widgets.scrollable.excludeFromSemantics}
  final bool excludeFromSemantics;

  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  /// If true, tapping an unselected item will animate to it as the new selection.
  /// This will also display a [SystemMouseCursors.click] cursor on hover on desktop.
  final bool tapToSelect;

  /// An optional listener that's called when the selected item changes.
  final ValueChanged<int>? onSelectedItemChanged;

  /// An optional listener that's called with the item index when the scroll settles
  /// or `null` when scrolling begins again.
  final ValueChanged<int?>? onSettledItemChanged;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.widgets.shadow.scrollBehavior}
  ///
  /// For example, this can be used to enable scrolling via mouse drag on desktop.
  ///
  /// [ScrollBehavior] also provides [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then [CustomCarouselScrollPhysics].
  final ScrollBehavior? scrollBehavior;

  /// Sets a default visual alignment for children. This effectively just wraps
  /// each child with its effects inside an [Align] widget. Setting it to `null`
  /// will remove the [Align] widget.
  final Alignment? alignment;

  /// Modifies the interaction between scroll gestures and the widget's scroll.
  /// A higher number will scroll faster. Defaults to 1.
  final double scrollSpeed;

  /// This method is responsible for animating the children based on the current scroll position.
  ///
  /// It is called once per visible child each time the scroll updates, and is passed the following arguments:
  /// - `index`: the index of the child in the [children] list
  /// - `scrollRatio`: the child's scroll position relative to the "center" of the scroll. This is a range between -1 and 1, where:
  ///    - `-1` indicates the furthest extent in the "before" direction
  ///    - `0` indicates the center; the neutral resting point for the selected item
  ///    - `+1` indicates the furthest extent in the "after" direction
  /// - `child`: the child widget
  ///
  /// The method should return a widget that wraps the child, and applies the desired effects based on `scrollRatio`.
  ///
  /// Note that `scrollRatio` may exceed -1 to 1, if the user overscrolls.
  ///
  /// See the "Cover Slider" and "Circular Menu" demos in `/example/lib/views/` for examples.
  final EffectsBuilder effectsBuilder;

  /// The number of items to display before the selected item.
  /// A reasonable default will be calculated if not provided.
  ///
  /// `itemCountBefore + itemCountBefore + 1` cannot be greater than `children.length`.
  final int? itemCountBefore;

  /// The number of items to display after the selected item.
  /// A reasonable default will be calculated if not provided.
  ///
  /// `itemCountBefore + itemCountBefore + 1` cannot be greater than `children.length`.
  final int? itemCountAfter;

  /// Determines the order in which items are displayed (ie. which items are in front of others).
  /// See [DepthOrder] for options.
  final DepthOrder depthOrder;

  /// If `true`, the view will scroll infinitely in both directions, looping
  /// the list of items.
  final bool loop;

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _lastReportedItemIndex = 0;
  double _viewportExtent = 1;
  int _itemCountBefore = 0;
  int _itemCountAfter = 0;
  bool _isSettled = true;
  final ValueNotifier<double> _scrollNotifier = ValueNotifier(0);

  CustomCarouselScrollController? _localScrollController;

  CustomCarouselScrollController get _scrollController =>
      widget.controller ??
      (_localScrollController ??= CustomCarouselScrollController());

  double get _virtualItemExtent => _viewportExtent / widget.scrollSpeed;

  Map<int, Widget> currentItemWidgetMap = {};

  @override
  void initState() {
    super.initState();
    _lastReportedItemIndex = _scrollController.initialItem;
    _updateCounts();
  }

  @override
  void didUpdateWidget(CustomCarousel oldWidget) {
    if (widget.itemCount != oldWidget.itemCount ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.itemCountBefore != oldWidget.itemCountBefore ||
        widget.itemCountAfter != oldWidget.itemCountAfter) {
      _updateCounts();
    }
    if (widget.controller != oldWidget.controller) {
      _localScrollController?.dispose();
      _localScrollController = null;
      _lastReportedItemIndex = _scrollController.initialItem;
      _updateScrollNotifier();
    }
    super.didUpdateWidget(oldWidget);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0 ||
        notification.metrics is! FixedExtentMetrics) {
      return false;
    }

    final FixedExtentMetrics metrics =
        notification.metrics as FixedExtentMetrics;
    final int currentItemIndex = metrics.itemIndex;

    if (notification is ScrollUpdateNotification) {
      if (_isSettled) {
        widget.onSettledItemChanged?.call(null);
        _isSettled = false;
      }
      if (currentItemIndex != _lastReportedItemIndex) {
        _lastReportedItemIndex = currentItemIndex;
        widget.onSelectedItemChanged?.call(currentItemIndex);
      }
      _updateScrollNotifier();
    } else if (notification is ScrollEndNotification && !_isSettled) {
      widget.onSettledItemChanged?.call(currentItemIndex);
      _isSettled = true;
    }

    return false;
  }

  void _updateCounts() {
    final int l = widget.itemCount - 1;
    _itemCountBefore = widget.itemCountBefore ??
        math.min(10, math.min(l >> 1, l - (widget.itemCountAfter ?? 0)));
    _itemCountAfter = widget.itemCountAfter ??
        math.min(10, math.min(l >> 1, l - (widget.itemCountBefore ?? 0)));
  }

  void _updateScrollNotifier() {
    if (!_scrollController.hasClients) return;
    final ScrollMetrics metrics = _scrollController.position;
    _scrollNotifier.value = metrics.pixels / _virtualItemExtent;
  }

  @override
  Widget build(BuildContext context) {
    /*
    General structure of the widget:
    - [LayoutBuilder] uses incoming constraints to calculate _virtualItemExtent
      ↳ [NotificationListener] updates a ValueNotifier with the scroll ratio
        ↳ [Scrollable] handles the scrolling, uses _virtualItemExtent for itemExtent
          ↳ [LayoutBuilder] sets the scrolling dimensions during the layout phase
            ↳ [AnimatedBuilder] builds the content when the ValueNotifier updates
    */
    return LayoutBuilder(builder: (_, constraints) {
      _viewportExtent = widget.scrollDirection == Axis.vertical
          ? constraints.maxHeight
          : constraints.maxWidth;
      _updateScrollNotifier();
      return _buildScrollDetector();
    });
  }

  Widget _buildScrollDetector() {
    // This NotificationListener listens for scroll updates from the Scrollable.
    return NotificationListener<ScrollNotification>(
      child: _buildScrollable(),
      onNotification: (notification) => _handleScrollNotification(notification),
    );
  }

  Widget _buildScrollable() {
    // The Scrollable manages user scroll interactions, and exposes necessary
    // properties to the scrollController.
    return CustomCarouselScrollable(
      controller: _scrollController,
      physics: widget.physics ?? const CustomCarouselScrollPhysics(),
      itemExtent: _virtualItemExtent,
      itemCount: widget.itemCount,
      loop: widget.loop,
      restorationId: widget.restorationId,
      scrollBehavior: widget.scrollBehavior ??
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
      excludeFromSemantics: widget.excludeFromSemantics,
      axisDirection: getAxisDirectionFromAxisReverseAndDirectionality(
        context,
        widget.scrollDirection,
        widget.reverse,
      ),
      viewportBuilder: (_, __) => _buildDimensionSetter(),
    );
  }

  Widget _buildDimensionSetter() {
    // This inner LayoutBuilder assigns the dimensions to the ScrollController's position
    // during the layout phase after the viewport has been laid out with its final dimensions.
    return LayoutBuilder(builder: (context, constraints) {
      final CustomCarouselScrollPosition position =
          _scrollController.positions.last as CustomCarouselScrollPosition;
      position.applyViewportDimension(_virtualItemExtent);

      double range = _virtualItemExtent * (widget.itemCount - 1);
      if (widget.loop) {
        // this provides a buffer to scroll into of 3x the range in each direction:
        position.applyContentDimensions(range * -3, range * 4);
      } else {
        position.applyContentDimensions(0, range);
      }
      return _buildContentBuilder(constraints);
    });
  }

  Widget _buildContentBuilder(BoxConstraints constraints) {
    // This AnimatedBuilder listens for scroll updates and rebuilds the content
    // when the scroll position changes.
    return AnimatedBuilder(
      animation: _scrollNotifier,
      builder: (context, child) {
        return _buildContent(context, constraints);
      },
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    final int l = widget.itemCount;

    final double position = _scrollNotifier.value;
    final int index = position.round();
    final double delta = index - position;

    // account for the selected item:
    final double rangeBefore = _itemCountBefore + 0.5;
    final double rangeAfter = _itemCountAfter + 0.5;

    int beginIndex = index - _itemCountBefore;
    int endIndex = index + _itemCountAfter;

    if (!widget.loop) {
      beginIndex = math.max(0, beginIndex);
      endIndex = math.min(l - 1, endIndex);
    }

    final int countBegin = index - beginIndex;
    final int countEnd = endIndex - index;
    final int countMax = math.max(countBegin, countEnd);

    // determine sort order:
    final bool beforeBelow = widget.depthOrder != DepthOrder.reverse;
    final bool afterBelow = widget.depthOrder != DepthOrder.forward;

    // the list of items that will be shown in the stack:
    final List<Widget> display = [];

    // add the selected item first:
    final double d = delta > 0 ? delta / rangeAfter : delta / rangeBefore;

    // alternate adding items, to support DepthOrder.selectedInFront

    if (currentItemWidgetMap[index] == null) {
      currentItemWidgetMap[index] = widget.itemBuilder.call(context, index);
    }

    _addItemTo(
        display, index, currentItemWidgetMap[index]!, constraints, d, false);

    for (int i = 1; i <= countMax; i++) {
      if (i <= countEnd) {
        if (currentItemWidgetMap[index + i] == null) {
          currentItemWidgetMap[index + i] =
              widget.itemBuilder.call(context, index + i);
        }

        _addItemTo(display, index + i, currentItemWidgetMap[index + i]!,
            constraints, (delta + i) / rangeAfter, afterBelow);
      }
    }

    for (int i = 1; i <= countMax; i++) {
      if (i <= countBegin) {
        if (currentItemWidgetMap[index - i] == null) {
          currentItemWidgetMap[index - i] =
              widget.itemBuilder.call(context, index - i);
        }
        _addItemTo(display, index - i, currentItemWidgetMap[index - i]!,
            constraints, (delta - i) / rangeBefore, beforeBelow);
      }
    }



    if (currentItemWidgetMap.values.length > (countBegin + countEnd + 1)) {
      currentItemWidgetMap
          .removeWhere((key, value) => key < beginIndex || key > endIndex);
    }

    return Stack(
      fit: StackFit.expand,
      children: display,
    );
  }

  void _addItemTo(List<Widget> list, int i, Widget item,
      BoxConstraints constraints, double pos, bool below) {
    final int l = widget.itemCount;

    if (widget.loop) i = (i + l) % l;

    // check for out of bounds due to overscroll:
    if (i < 0 || i >= l) return;

    if (widget.addRepaintBoundaries) {
      item = RepaintBoundary(child: item);
    }

    if (i != _lastReportedItemIndex && widget.tapToSelect) {
      item = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _scrollController.animateToItem(i),
          child: AbsorbPointer(child: item),
        ),
      );
    }

    if (widget.addSemanticIndexes) {
      item = IndexedSemantics(index: i, child: item);
    }

    item = widget.effectsBuilder(i, pos, constraints, item);

    if (widget.alignment != null) {
      item = Align(alignment: widget.alignment!, child: item);
    }

    // list.add(item);

    if (below) {
      list.add(item);

    } else {
      list.insert(0, item);

    }
  }
}

/// Method signature for [CustomCarousel.effectsBuilder].
typedef EffectsBuilder = Widget Function(
  int index,
  double scrollRatio,
  BoxConstraints constraints,
  Widget child,
);

/// The order in which items are displayed (back to front) in [CustomCarousel].
enum DepthOrder {
  /// Items are displayed in the order they appear in `children`.
  /// That is, items earlier in the list are drawn behind items later in the list.
  forward,

  /// Items are displayed in the reverse of the order they appear in `children`.
  /// That is, items earlier in the list are drawn in front of items later in the list.
  reverse,

  /// Items closer to the selected item in `children` are drawn in front of items further from the selected item.
  /// The selected item is always in the front.
  selectedInFront,
}
