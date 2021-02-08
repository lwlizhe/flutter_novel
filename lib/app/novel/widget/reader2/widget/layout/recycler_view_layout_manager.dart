 import 'package:flutter/widgets.dart';

abstract class LayoutManager{

  List<Element> cacheElement=[];

}

class LinearLayoutManager extends LayoutManager{
  @override
  int getItemCount() {

  }

  @override
  int getItemType() {

  }

  @override
  Widget getItemWidget() {
    return null;
  }

}
