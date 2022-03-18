import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum FilterType {
  OPACITY,
  ROTATE_TRANSFORM,
  ROTATE_FILTER,
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _useRepaintBoundary = false;
  bool _cacheTransformChild = false;
  bool _complexChild = false;
  FilterType? _filterType;
  GlobalKey _childKey = GlobalKey(debugLabel: 'child to animate');
  Offset _childCenter = Offset.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      RenderBox childBox =
          _childKey.currentContext?.findRenderObject() as RenderBox;
      _childCenter = childBox.paintBounds.center;
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setFilterType(FilterType type, bool selected) {
    setState(() => _filterType = selected ? type : null);
  }

  List<Widget> makeComplexChildList(int rows, int cols, double w, double h) {
    List<Widget> children = <Widget>[];
    double sx = w / cols;
    double sy = h / rows;
    double tx = -sx * cols / 2.0;
    double ty = -sy * rows / 2.0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        children.add(RepaintBoundary(
            child: Transform(
          child: Text('text'),
          transform: Matrix4.translationValues(c * sx + tx, r * sy + ty, 0.0),
        )));
      }
    }
    return children;
  }

  static Widget _makeChild(int rows, int cols, double fontSize, bool complex) {
    BoxDecoration decoration = BoxDecoration(
      color: Colors.green,
      boxShadow: complex
          ? <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 10.0,
              ),
            ]
          : null,
      borderRadius: BorderRadius.circular(10.0),
    );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(
              rows,
              (r) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(
                        cols,
                        (c) => Container(
                              child: Text('text',
                                  style: TextStyle(fontSize: fontSize)),
                              decoration: decoration,
                            )),
                  )),
        ),
        Text(
          'child',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ],
    );
  }

  static Widget _protectChild({required Widget child, required bool protect}) {
    if (protect) {
      child = RepaintBoundary(
        child: child,
      );
    }
    return child;
  }

  Widget buildOpacity(BuildContext context, Widget child) {
    return Opacity(
      opacity: (_controller.value * 2.0 - 1.0).abs(),
      child: child,
    );
  }

  Widget _animate(Widget child) {
    if (_filterType == null) {
      _controller.reset();
      return child;
    }
    _controller.repeat();
    Function? builder;
    switch (_filterType) {
      case FilterType.OPACITY:
        builder = (context, child) => Opacity(
              opacity: (_controller.value * 2.0 - 1.0).abs(),
              child: child,
            );
        break;
      case FilterType.ROTATE_TRANSFORM:
        builder = (center, child) => Transform.scale(
              scale: _controller.value,
              filterQuality: _cacheTransformChild ? FilterQuality.none : null,
              alignment: Alignment.center,
              child: child,
            );
        // builder = (center, child) => Transform(
        //       transform: Matrix4.rotationZ(_controller.value * 2.0 * pi),
        //       // transform: Matrix4.rotationZ(_controller.value * 2.0 * pi),
        //       // method: _cacheTransformChild
        //       //     ? TransformMethod.bitmapTransform
        //       //     : TransformMethod.render,
        //       filterQuality: _cacheTransformChild ? FilterQuality.none : null,
        //       alignment: Alignment.center,
        //       child: child,
        //     );
        break;
      case FilterType.ROTATE_FILTER:
        builder = (center, child) => ImageFiltered(
              imageFilter: ImageFilter.matrix(
                (Matrix4.identity()
                      // ..translate(_childCenter.dx, _childCenter.dy)
                      ..scale(_controller.value)
                    // ..translate(-_childCenter.dx, -_childCenter.dy)
                    )
                    .storage,
              ),
              child: child,
            );
        break;
    }
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: child,
        builder: (context, child) {
          return builder?.call(context, child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: Center(
        child: _animate(
          _protectChild(
            child: Container(
              key: _childKey,
              color: Colors.yellow,
              width: 300,
              height: 300,
              child: Center(
                child: _makeChild(4, 3, 24.0, _complexChild),
              ),
            ),
            protect: _useRepaintBoundary,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Opacity:'),
                Checkbox(
                  value: _filterType == FilterType.OPACITY,
                  onChanged: (b) =>
                      _setFilterType(FilterType.OPACITY, b ?? false),
                ),
                Text('Tx Rotate:'),
                Checkbox(
                  value: _filterType == FilterType.ROTATE_TRANSFORM,
                  onChanged: (b) =>
                      _setFilterType(FilterType.ROTATE_TRANSFORM, b ?? false),
                ),
                Text('IF Rotate:'),
                Checkbox(
                  value: _filterType == FilterType.ROTATE_FILTER,
                  onChanged: (b) =>
                      _setFilterType(FilterType.ROTATE_FILTER, b ?? false),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Complex child:'),
                Checkbox(
                  value: _complexChild,
                  onChanged: (b) => setState(() => _complexChild = b ?? false),
                ),
                Text('Child RPB:'),
                Checkbox(
                  value: _useRepaintBoundary,
                  onChanged: (b) =>
                      setState(() => _useRepaintBoundary = b ?? false),
                ),
                Text('cache tx:'),
                Checkbox(
                  value: _cacheTransformChild,
                  onChanged: (b) =>
                      setState(() => _cacheTransformChild = b ?? false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
