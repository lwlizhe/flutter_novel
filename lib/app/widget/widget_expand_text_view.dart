import 'package:flutter/material.dart';

const Duration _animationDuration = Duration(milliseconds: 300);

/// 这是expand_widget[https://pub.dev/packages/expand_widget] 的中国特色社会主义改造版

class ExpandText extends StatefulWidget {
  final String minMessage, maxMessage;
  final Color arrowColor;
  final double arrowSize;

  final Duration animationDuration;
  final String text;
  final int maxLength;

  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;

  final GlobalKey<_ExpandTextState> textKey;
  final bool isHiddenArrow;

  const ExpandText(this.text,
      {this.textKey,
      this.minMessage = 'Show more',
      this.maxMessage = 'Show less',
      this.arrowColor,
      this.arrowSize = 27,
      this.animationDuration = _animationDuration,
      this.maxLength = 8,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.isHiddenArrow})
      : super(key: textKey);

  @override
  _ExpandTextState createState() => _ExpandTextState();

  void toggle() {
    if (textKey != null && textKey.currentState != null) {
      textKey.currentState.toggle();
    }
  }
}

class _ExpandTextState extends State<ExpandText>
    with TickerProviderStateMixin<ExpandText> {
  /// Custom animations curves for both height & arrow controll.
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeInOutCubic);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  /// General animation controller.
  AnimationController _controller;

  /// Animation for controlling the height of the widget.
  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    /// Initializing the animation controller with the [duration] parameter.
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    /// Initializing the animation, depending on the [_easeInTween] curve.
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Method called when the user clicks on the expand arrow.
  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  void toggle() {
    _handleTap();
  }

  /// Builds the widget itself. If the [_isExpanded] parameters is [true],
  /// the [child] parameter will contain the child information, passed to
  /// this instance of the object.
  Widget _buildChildren(BuildContext context, Widget child) {
    return LayoutBuilder(builder: (context, size) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: widget.text,
          style: widget.style,
        ),
        textDirection: TextDirection.rtl,
        maxLines: widget.maxLength,
      )..layout(maxWidth: size.maxWidth);

      return textPainter.didExceedMaxLines&&(widget?.isHiddenArrow==null||!widget.isHiddenArrow)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedSize(
                  vsync: this,
                  duration: widget.animationDuration,
                  alignment: Alignment.topCenter,
                  curve: Curves.easeInOutCubic,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: child,
                  ),
                ),
                ExpandArrow(
                  minMessage: widget.minMessage,
                  maxMessage: widget.maxMessage,
                  color: widget.arrowColor,
                  size: widget.arrowSize,
                  animation: _iconTurns,
                  onTap: _handleTap,
                ),
              ],
            )
          : child;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: Text(
        widget.text,
        textAlign: widget.textAlign,
        overflow: TextOverflow.fade,
        style: widget.style,
        maxLines: _isExpanded ? null : widget.maxLength,
      ),
    );
  }
}

class ExpandArrow extends StatefulWidget {
  final String minMessage, maxMessage;
  final Animation<double> animation;
  final Function onTap;
  final Color color;
  final double size;

  const ExpandArrow({
    this.minMessage,
    this.maxMessage,
    @required this.animation,
    @required this.onTap,
    this.color,
    this.size,
  });

  @override
  _ExpandArrowState createState() => _ExpandArrowState();
}

class _ExpandArrowState extends State<ExpandArrow> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _message,
      child: InkResponse(
        child: RotationTransition(
          turns: widget.animation,
          child: Icon(
            Icons.expand_more,
            color: widget.color ?? Theme.of(context).textTheme.caption.color,
            size: widget.size,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }

  /// Shows a tooltip message depending on the [animation] state.
  String get _message =>
      widget.animation.value == 0 ? widget.minMessage : widget.maxMessage;
}
