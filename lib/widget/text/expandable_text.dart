import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TextExpandedCallback = Function(bool);

/// 具备展开收起功能的文字面板
///
/// 布局规则：
///     在文本的右下角有更多或者收起按钮
///     当文本超过指定的[maxLines]时，剩余文本隐藏
///     点击更多，则显示全部文本
///
/// ```dart
///   BrnExpandableText(
///      text: '在文本的右下角有更多或者收起按钮',
///   )
///
///   BrnExpandableText(
///      text: '具备展开收起功能的文字面板，在文本的右下角有更多或者收起按钮',
///      maxLines: 2,
///      onExpanded: (value) {
///      },
///   )
///
///
/// ```
///
/// 相关文本组件如下:
///  * [BrnBubbleText], 气泡背景的展开收起文本组件
///  * [BrnInsertInfo], 气泡背景的文本组件
///
/// copy from https://github.com/LianjiaTech/bruno/blob/master/lib/src/components/text/brn_expandable_text.dart
class BrnExpandableText extends StatefulWidget {
  ///显示的文本
  final String text;

  ///显示的最多行数
  final int maxLines;

  /// 文本的样式
  final TextStyle? textStyle;

  /// 展开或者收起的时候的回调
  final TextExpandedCallback? onExpanded;

  /// 更多按钮渐变色的初始色 默认白色
  final Color color;

  const BrnExpandableText(
      {Key? key,
      required this.text,
      this.maxLines = 1000000,
      this.textStyle,
      this.onExpanded,
      this.color = Colors.white})
      : super(key: key);

  _BrnExpandableTextState createState() => _BrnExpandableTextState();
}

class _BrnExpandableTextState extends State<BrnExpandableText> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = _defaultTextStyle();
    return LayoutBuilder(
      builder: (context, size) {
        final span = TextSpan(text: widget.text, style: style);
        final tp = TextPainter(
            text: span,
            maxLines: widget.maxLines,
            textDirection: TextDirection.ltr,
            ellipsis: 'EllipseText');
        tp.layout(maxWidth: size.maxWidth);
        if (tp.didExceedMaxLines) {
          if (this._expanded) {
            return _expandedText(context, widget.text);
          } else {
            return _foldedText(context, widget.text);
          }
        } else {
          return _regularText(widget.text, style);
        }
      },
    );
  }

  Widget _foldedText(context, String text) {
    return Stack(
      children: <Widget>[
        Text(
          widget.text,
          style: _defaultTextStyle(),
          maxLines: widget.maxLines,
          overflow: TextOverflow.clip,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _clickExpandTextWidget(context),
        )
      ],
    );
  }

  Widget _clickExpandTextWidget(context) {
    Color btnColor = Color(0xFF4E4E4E);

    Text tx = Text(
      '更多',
      style: TextStyle(fontSize: 14, color: Colors.blue),
    );
    Container cnt = Container(
      padding: EdgeInsets.only(left: 22),
      alignment: Alignment.centerRight,
      child: tx,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [btnColor.withAlpha(100), btnColor, btnColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      )),
    );
    return GestureDetector(
      child: cnt,
      onTap: () {
        setState(() {
          _expanded = true;
          if (null != widget.onExpanded) {
            widget.onExpanded!(_expanded);
          }
        });
      },
    );
  }

  Widget _expandedText(context, String text) {
    return RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(text: text, style: _defaultTextStyle(), children: [
          _foldButtonSpan(context),
        ]));
  }

  TextStyle _defaultTextStyle() {
    TextStyle style = widget.textStyle ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );
    return style;
  }

  InlineSpan _foldButtonSpan(context) {
    return TextSpan(
        text: ' 收起',
        style: TextStyle(fontSize: 14, color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            setState(() {
              _expanded = false;
              if (null != widget.onExpanded) {
                widget.onExpanded!(_expanded);
              }
            });
          });
  }

  Widget _regularText(text, style) {
    return Text(text, style: style);
  }
}
