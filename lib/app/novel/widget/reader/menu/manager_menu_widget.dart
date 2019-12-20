import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Duration _bottomSheetDuration = Duration(milliseconds: 200);

typedef void OnMenuItemClicked(MenuOperateEnum operateName, var operateData);

enum MenuOperateEnum {
  OPERATE_NEXT_CHAPTER,
  OPERATE_PRE_CHAPTER,
  OPERATE_JUMP_CHAPTER,
  OPERATE_OPEN_CATALOG,
  OPERATE_TOGGLE_NIGHT_MODE,
  OPERATE_OPEN_SETTING,

  OPERATE_SETTING_FONT_SIZE,
  OPERATE_SETTING_LINE_HEIGHT,
  OPERATE_SETTING_PARAGRAPH_SPACING,
  OPERATE_SETTING_ANIMATION_MODE,
  OPERATE_SETTING_BG_COLOR,
}

class NovelMenuManager {
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _bottomSheetDuration,
      debugLabel: 'BottomSheet',
      vsync: vsync,
    );
  }
}

class NovelPagePanGestureRecognizer extends PanGestureRecognizer {
  bool isMenuOpen;

  NovelPagePanGestureRecognizer(this.isMenuOpen);

  void setMenuOpen(bool isOpen){
    isMenuOpen=isOpen;
  }

  @override
  String get debugDescription => "novel page pan gesture recognizer";

  @override
  void addPointer(PointerDownEvent event) {
    if (!isMenuOpen) {
      super.addPointer(event);
    }
  }
}

class NovelMenuLayoutDelegate extends SingleChildLayoutDelegate {
  NovelMenuLayoutDelegate(this.progress, this.isTopSheet);

  final double progress;
  final bool isScrollControlled = false;
  final bool isTopSheet;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
        0.0,
        isTopSheet
            ? -childSize.height * (1 - progress)
            : size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(NovelMenuLayoutDelegate oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
