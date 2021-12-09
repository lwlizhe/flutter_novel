import 'package:flutter/material.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';
import 'package:test_project/scroll/layout/manager/simulation/power_list_simulation_layout_manager.dart';
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
                addRepaintBoundaries: false,
                scrollDirection: Axis.horizontal,
                // layoutManager: PowerListCoverLayoutManager(),
                layoutManager: PowerListSimulationTurnLayoutManager(),
                itemBuilder: (_context, _index) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: colorList[_index % 4],
                        alignment: AlignmentDirectional.topCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Stack(
                            children: [
                              Text(
                                '第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第二页第二页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，第$_index页，',
                                style: TextStyle(fontSize: 20),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Text(
                                    '页码:$_index',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Text(
                                    '页码:$_index (在右上角)',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ],
                          ),
                        ),
                      ));
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
