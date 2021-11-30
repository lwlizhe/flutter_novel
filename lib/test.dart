import 'package:flutter/material.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';
import 'package:test_project/scroll/layout/manager/simulation/power_list_simulation_layout_manager.dart';
import 'package:test_project/scroll/notify/power_list_data_notify.dart';
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
    var controller = PowerListScrollController();

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              PowerListView.builder(
                physics: PageScrollPhysics(),
                controller: controller,
                // addRepaintBoundaries: false,
                scrollDirection: Axis.horizontal,
                // layoutManager: PowerListCoverLayoutManager(),
                layoutManager: PowerListSimulationTurnLayoutManager(),
                itemBuilder: (_context, _index) {
                  var notify =
                      PowerListDataInheritedWidget.of(_context)?.gestureNotify;

                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: _index == 0
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.red,
                              alignment: AlignmentDirectional.topCenter,
                              child: Text(
                                '第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第二页第二页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          // ? SimulationCustomPaint(
                          //     child: TestItemPage(Colors.yellow),
                          //     gestureDataNotify: notify,
                          //     position: controller.position,
                          //     // child: ColoredBox(
                          //     //   color: Colors.green,
                          //     //   child: SizedBox(
                          //     //     width: double.infinity,
                          //     //     height: double.infinity,
                          //     //   ),
                          //     // ),
                          //   )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: colorList[_index % 4],
                              alignment: AlignmentDirectional.topCenter,
                              child: Text(
                                '第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第二页第二页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页',
                                style: TextStyle(fontSize: 20),
                              ),
                            ));
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
                itemCount: 10,
              ),
              GestureDetector(
                onTap: () {
                  controller.animateTo(1000,
                      duration: Duration(seconds: 3),
                      curve: Curves.linearToEaseOut);
                },
                child: Container(
                  height: 100,
                  child: Text(
                    'test',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
