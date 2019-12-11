import 'package:flutter/material.dart';


abstract class BaseItemHolder<T> extends StatefulWidget {

  final T currentHolderData;

  BaseItemHolder(this.currentHolderData);

  BaseItemHolderState<T> initState();

  @override
  State<StatefulWidget> createState() {
    return initState().setHolderData(currentHolderData);
  }

}

 abstract class BaseItemHolderState<T>
    extends State<BaseItemHolder> {
  T mCurrentHolderData;

  BaseItemHolderState setHolderData(T data) {
    mCurrentHolderData = data;
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }

  Widget buildView(BuildContext context);


 }
