import 'package:flutter/material.dart';

Widget buildButton({
  required BuildContext context,
  VoidCallback? onPressCallback,
  Size? minimumSize,
  TextStyle? textStyle,
  MaterialStateProperty<OutlinedBorder?>? styleShape,
  EdgeInsetsGeometry? padding,
  Color? overlayColor,
  Color? backgroundColor,
  required WidgetBuilder childWidgetBuilder,
}) {
  return TextButton(
    onPressed: onPressCallback,
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsDirectional>(
          EdgeInsetsDirectional.zero),
      minimumSize: minimumSize != null
          ? MaterialStateProperty.all<Size?>(minimumSize)
          : MaterialStateProperty.all<Size?>(Size(1, 1)),
      shape: styleShape,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      overlayColor: MaterialStateProperty.all<Color>(
          overlayColor ?? Colors.grey.withAlpha(75)),
      backgroundColor: backgroundColor != null
          ? MaterialStateProperty.all<Color>(backgroundColor)
          : null,
    ),
    child: Builder(builder: childWidgetBuilder),
  );
}
