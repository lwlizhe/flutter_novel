import 'package:flutter/material.dart';

class NovelConfigInfo {
  final TextStyle contentTextStyle;
  final TextStyle titleTextStyle;
  final double paragraphSpacing;
  final double displayHeight;
  final double displayWidth;

  const NovelConfigInfo({
    this.contentTextStyle = const TextStyle(fontSize: 16, height: 1.5),
    this.titleTextStyle = const TextStyle(fontSize: 20, height: 1.5),
    this.paragraphSpacing = 10,
    this.displayWidth = 0,
    this.displayHeight = 0,
  });

  NovelConfigInfo copyWith({
    TextStyle? contentTextStyle,
    TextStyle? titleTextStyle,
    double? paragraphSpacing,
  }) {
    return NovelConfigInfo(
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
    );
  }
}
