import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/power_scroll_view.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final colorList = <MaterialAccentColor>[
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: PowerListView.builder(
            physics: PageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            layoutManager: PowerListCoverLayoutManager(),
            itemBuilder: (_context, _index) {
              return GestureDetector(
                onTapDown: (_detail) {
                  Fluttertoast.showToast(
                      msg:
                          'click index :$_index , detail localPosition is ${_detail.localPosition} , detail globalPosition is ${_detail.globalPosition}');
                },
                child: Transform(
                  transform: Matrix4.identity(),
                  child: Container(
                    color: colorList[_index % 4],
                    alignment: AlignmentDirectional.center,
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text('test$_index'),
                  ),
                ),
              );
            },
            itemCount: 20,
          ),
        ),
      ),
    );
  }
}
