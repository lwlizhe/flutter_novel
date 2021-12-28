import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

mixin NestedScrollParent {
  bool onStartNestedScroll(target, int axes);

  void onNestedScrollAccepted(target, int axes);

  void onStopNestedScroll(target);

  void onNestedScroll(target, int dxConsumed, int dyConsumed, int dxUnconsumed,
      int dyUnconsumed);

  void onNestedPreScroll(target, int dx, int dy, Offset consumed);

  bool onNestedFling(target, double velocityX, double velocityY, bool consumed);

  bool onNestedPreFling(target, double velocityX, double velocityY);

  int getNestedScrollAxes();
}

mixin NestedScrollChild {
  void setNestedScrollingEnabled(bool enabled);

  bool isSupportNestedScroll();

  bool startNestedScroll(int axes);

  void stopNestedScroll();

  bool hasNestedScrollingParent();

  bool dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed,
      int dyUnconsumed, Offset offsetInWindow);

  bool dispatchNestedPreScroll(
      int dx, int dy, Offset consumed, Offset offsetInWindow);

  bool dispatchNestedFling(double velocityX, double velocityY, bool consumed);

  bool dispatchNestedPreFling(double velocityX, double velocityY);

  NestedScrollParent? findNestedParent();
}

class NestedScrollChildHelper {
  NestedScrollChild nestedChild;
  NestedScrollParent? nestedParent;
  bool mIsNestedScrollingEnabled = false;
  Offset mTempNestedScrollConsumed = Offset.zero;

  NestedScrollChildHelper(this.nestedChild);

  void setNestedScrollingEnabled(bool enabled) {
    if (mIsNestedScrollingEnabled) {}
    mIsNestedScrollingEnabled = enabled;
  }

  bool isNestedScrollingEnabled() {
    return mIsNestedScrollingEnabled;
  }

  bool hasNestedScrollingParent() {
    return nestedParent != null;
  }

  bool startNestedScroll(int axes) {
    if (hasNestedScrollingParent()) {
      // Already in progress
      return true;
    }
    if (isNestedScrollingEnabled()) {
      NestedScrollParent? parent = nestedChild.findNestedParent();
      NestedScrollChild child = nestedChild;
      if (parent != null) {
        if (parent.onStartNestedScroll(nestedChild, axes)) {
          nestedParent = parent;
          nestedParent!.onNestedScrollAccepted(nestedChild, axes);
          return true;
        }
      }
    }
    return false;
  }

  void stopNestedScroll() {
    if (nestedParent != null) {
      nestedParent!.onStopNestedScroll(nestedChild);
      nestedParent = null;
    }
  }

  // void dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed,
  //     int dyUnconsumed, Offset offsetInWindow, int type, Offset consumed) {
  //   dispatchNestedScrollInternal(dxConsumed, dyConsumed, dxUnconsumed,
  //       dyUnconsumed, offsetInWindow, type, consumed);
  // }

  void dispatchNestedScrollInternal(
    Offset offsetInWindow,
    Offset consumed,
    Offset unConsumed,
  ) {}
}
