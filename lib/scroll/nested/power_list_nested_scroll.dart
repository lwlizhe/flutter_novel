import 'package:flutter/material.dart';
import 'package:test_project/scroll/nested/nested_scroll.dart';

mixin PowerListNestedScrollParent on NestedScrollParent {
  ScrollController getNestedScrollController();
}

mixin PowerListNestedScrollChild on NestedScrollChild {
  ScrollController getNestedScrollController();
}
