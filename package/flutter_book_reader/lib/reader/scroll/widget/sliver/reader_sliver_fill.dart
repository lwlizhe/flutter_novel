import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../rendering/reader_sliver_fill.dart';

class ReaderSliverFillViewport extends SliverFillViewport {
  const ReaderSliverFillViewport({
    super.key,
    required super.delegate,
    super.viewportFraction = 1.0,
    super.padEnds = true,
  });

  @override
  Widget build(BuildContext context) {
    return _SliverFractionalPadding(
      viewportFraction:
          padEnds ? clampDouble(1 - viewportFraction, 0, 1) / 2 : 0,
      sliver: _SliverFillViewportRenderObjectWidget(
        viewportFraction: viewportFraction,
        delegate: delegate,
      ),
    );
  }
}

class _SliverFillViewportRenderObjectWidget
    extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportRenderObjectWidget({
    required super.delegate,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  final double viewportFraction;

  @override
  ReaderRenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return ReaderRenderSliverFillViewport(
        childManager: element, viewportFraction: viewportFraction);
  }

  @override
  void updateRenderObject(
      BuildContext context, ReaderRenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _SliverFractionalPadding extends SingleChildRenderObjectWidget {
  const _SliverFractionalPadding({
    this.viewportFraction = 0,
    Widget? sliver,
  })  : assert(viewportFraction >= 0),
        assert(viewportFraction <= 0.5),
        super(child: sliver);

  final double viewportFraction;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliverFractionalPadding(viewportFraction: viewportFraction);

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverFractionalPadding renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _RenderSliverFractionalPadding extends RenderSliverEdgeInsetsPadding {
  _RenderSliverFractionalPadding({
    double viewportFraction = 0,
  })  : assert(viewportFraction <= 0.5),
        assert(viewportFraction >= 0),
        _viewportFraction = viewportFraction;

  SliverConstraints? _lastResolvedConstraints;

  double get viewportFraction => _viewportFraction;
  double _viewportFraction;

  set viewportFraction(double newValue) {
    if (_viewportFraction == newValue) {
      return;
    }
    _viewportFraction = newValue;
    _markNeedsResolution();
  }

  @override
  EdgeInsets? get resolvedPadding => _resolvedPadding;
  EdgeInsets? _resolvedPadding;

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  void _resolve() {
    if (_resolvedPadding != null && _lastResolvedConstraints == constraints) {
      return;
    }

    final double paddingValue =
        constraints.viewportMainAxisExtent * viewportFraction;
    _lastResolvedConstraints = constraints;
    switch (constraints.axis) {
      case Axis.horizontal:
        _resolvedPadding = EdgeInsets.symmetric(horizontal: paddingValue);
      case Axis.vertical:
        _resolvedPadding = EdgeInsets.symmetric(vertical: paddingValue);
    }

    return;
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }
}
