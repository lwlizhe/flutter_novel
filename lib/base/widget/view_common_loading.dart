import 'package:flutter/material.dart';

class CommonLoadingView extends StatefulWidget {
  @override
  _CommonLoadingViewState createState() => _CommonLoadingViewState();
}

class _CommonLoadingViewState extends State<CommonLoadingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("默认的通用loading页面"),
    );
  }
}
