import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PowerListDataInheritedWidget extends InheritedWidget {
  PowerListDataInheritedWidget({
    Key? key,
    this.gestureNotify,
    this.indexNotify,
    required Widget child,
  }) : super(key: key, child: child);

  final PowerListGestureDataNotify? gestureNotify;
  final PowerListIndexDataNotify? indexNotify;

  static PowerListDataInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PowerListDataInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant PowerListDataInheritedWidget oldWidget) {
    return (oldWidget.gestureNotify != this.gestureNotify) ||
        (oldWidget.indexNotify != this.indexNotify);
  }
}

class PowerListGestureDataNotify extends ChangeNotifier {
  PointerEvent? pointerEvent;

  void setSignalEvent(PointerEvent event) {
    this.pointerEvent = event;
    notifyListeners();
  }
}

class PowerListIndexDataNotify extends ChangeNotifier {
  int? index;

  void setIndex(int index) {
    this.index = index;
    notifyListeners();
  }

  @override
  bool operator ==(other) {
    return other is PowerListIndexDataNotify && index == other.index;
  }

  @override
  int get hashCode => index.hashCode;
}
