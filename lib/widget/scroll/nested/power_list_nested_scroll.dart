import 'package:flutter/material.dart';
import 'package:flutter_novel/widget/scroll/nested/nested_scroll.dart';

mixin PowerListNestedScrollParent on NestedScrollParent {
  ScrollController getNestedScrollController();
}

mixin PowerListNestedScrollChild on NestedScrollChild {
  ScrollController getNestedScrollController();
}
