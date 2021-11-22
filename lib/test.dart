import 'package:flutter/material.dart';
import 'package:test_project/item/test_page.dart';
import 'package:test_project/page/simulation_custom_paint.dart';
import 'package:test_project/scroll/layout/manager/layout_manager.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';
import 'package:test_project/scroll/power_scroll_view.dart';

import 'page/simulation_turn_page_painter.dart';

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
          color: Colors.white,
          child: PowerListView.builder(
            physics: PageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            layoutManager: PowerListSimulationTurnLayoutManager(),
            itemBuilder: (_context, _index) {
              var notify =
                  PowerListDataInheritedWidget.of(_context)?.gestureNotify;

              print('get inheritedWidget : ${notify?.pointerEvent}');

              return Container(
                  width: MediaQuery.of(context).size.width,
                  child: _index == 0
                      ? SimulationCustomPaint(
                          foregroundPainter:
                              SimulationForegroundTurnPagePainter(),
                          painter: SimulationTurnPagePainter(),
                          child: TestItemPage(Colors.yellow),
                          gestureDataNotify: notify,
                          // child: ColoredBox(
                          //   color: Colors.green,
                          //   child: SizedBox(
                          //     width: double.infinity,
                          //     height: double.infinity,
                          //   ),
                          // ),
                        )
                      : TestItemPage(Colors.red));
              // return Container(
              //   color: colorList[_index % 4],
              //   alignment: AlignmentDirectional.center,
              //   width: MediaQuery.of(context).size.width,
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              //   child: Container(
              //     child: _index == 0
              //         ? CustomPaint(
              //             foregroundPainter: SimulationTurnPagePainter(),
              //             child: TestItemPage(Colors.red),
              //           )
              //         : TestItemPage(Colors.blue),
              //   ),
              // );
            },
            itemCount: 2,
          ),
        ),
      ),
    );
  }
}
