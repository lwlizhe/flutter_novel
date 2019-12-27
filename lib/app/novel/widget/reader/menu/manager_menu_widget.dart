import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/util/utils_screen.dart';

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
  OPERATE_SELECT_CHAPTER,
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

  void setMenuOpen(bool isOpen) {
    isMenuOpen = isOpen;
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
  NovelMenuLayoutDelegate(this.progress, this.direction);

  final double progress;
  final MenuDirection direction;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth:
          direction == MenuDirection.DIRECTION_LEFT ? 0 : constraints.maxWidth,
      maxWidth: direction == MenuDirection.DIRECTION_LEFT
          ? ScreenUtils.getScreenWidth() / 4*3
          : constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: direction == MenuDirection.DIRECTION_LEFT
          ? constraints.maxHeight
          : constraints.maxHeight * 9.0 / 16.0,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double offsetDy = 0.0;
    double offsetDx = 0.0;

    switch (direction) {
      case MenuDirection.DIRECTION_BOTTOM:
        offsetDy = size.height - childSize.height * progress;
        break;
      case MenuDirection.DIRECTION_TOP:
        offsetDy = -childSize.height * (1 - progress);
        break;
      case MenuDirection.DIRECTION_LEFT:
        offsetDx = -childSize.width * (1 - progress);
        break;
    }

    return Offset(offsetDx, offsetDy);
  }

  @override
  bool shouldRelayout(NovelMenuLayoutDelegate oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

enum MenuDirection {
  DIRECTION_BOTTOM,
  DIRECTION_TOP,
  DIRECTION_LEFT,
}
