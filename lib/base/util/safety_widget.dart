import 'package:flutter/cupertino.dart';

mixin SafetyState<T extends StatefulWidget> on State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
