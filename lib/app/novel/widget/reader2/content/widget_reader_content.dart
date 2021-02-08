import 'dart:math';

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/recycler_view.dart';

class NovelPageReader2 extends StatefulWidget {
  NovelPageReader2(Key readerKey) : super();

  @override
  _NovelPageReaderState createState() => _NovelPageReaderState();
}

class _NovelPageReaderState extends State<NovelPageReader2> {
  List<int> list = [];
  List<ValueListenable> dataList = [];
  ValueNotifier<List<int>> dataList2Notify = ValueNotifier<List<int>>([]);

  List<MaterialColor> colorsList = [
    Colors.red,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.yellow
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      list.add(i);
    }

    dataList = list.map((e) => new ValueNotifier<int>(e)).toList();
    dataList2Notify.value = list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RecyclerView.builder(
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            var item = dataList[index];
            return ValueListenableBuilder<int>(
                valueListenable: item,
                builder: (context, value, child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange[700]]), //背景渐变
                        borderRadius: BorderRadius.circular(3.0), //3像素圆角
                        boxShadow: [
                          //阴影
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(3.0, -2.0),
                              blurRadius: 4.0)
                        ]),
                    child: RepaintBoundary.wrap(
                        Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            color: colorsList[
                                value.toInt() % (colorsList.length - 1)],
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  value.toString(),
                                ))),
                        value.toInt()),
                  );
                });
          }),
    );
  }
}
