import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/item/split/content_manager.dart';
import 'package:test_project/item/split/content_split_util.dart';
import 'package:test_project/scroll/controller/power_list_scroll_controller.dart';
import 'package:test_project/scroll/controller/power_list_scroll_simulation_controller.dart';
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

  var content = '';

  var controller = PowerListScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> loadBook() async {
    var s = await rootBundle.loadString('assets/test.txt', cache: false);
    content = s;
    return s;
  }

  Future<List<ReaderChapterPageContentConfig>> loadAsset(
      double contentWidth, double contentHeight) async {
    print('asset load start : ${DateTime.now().millisecondsSinceEpoch}');
    var s = await loadBook();

    print('asset load asset : ${DateTime.now().millisecondsSinceEpoch}');

    print('asset load parse start : ${DateTime.now().millisecondsSinceEpoch}');

    var info = ContentSplitUtil.getChapterPageContentConfigList(
        content: s,
        contentHeight: contentHeight,
        contentWidth: contentWidth,
        fontSize: 16,
        lineHeight: 32,
        paragraphSpacing: 0);
    print('asset load end : ${DateTime.now().millisecondsSinceEpoch}');
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FutureBuilder<String>(
                    future: loadBook(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (!snapshot.hasData) {
                        return Text('loading');
                      } else {
                        controller = PowerListScrollSimulationController();
                        return PowerListView.builder(
                          physics: PageScrollPhysics(),
                          controller: controller,
                          // controller: PowerListScrollController(),
                          addRepaintBoundaries: false,
                          scrollDirection: Axis.horizontal,
                          // layoutManager: PowerListCoverLayoutManager(),
                          layoutManager: PowerListSimulationTurnLayoutManager(),
                          itemBuilder: (BuildContext context, int _index) {
                            return buildContentItem(constraints, _index);
                            // return buildTestContentItem(constraints, _index);
                          },
                          itemCount: 3,
                        );
                      }
                    },
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  controller.jumpTo(0);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.white,
                  child: Text('jump'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContentItem(BoxConstraints constraints, int _index) {
    ReaderChapterPageContentConfig config = ReaderChapterPageContentConfig();
    config.paragraphContents = [];
    config.pendingPartContent = content;
    config.currentContentFontSize = 16;
    config.currentContentLineHeight = 32;
    config.currentContentParagraphSpacing = 0;
    config.currentPageIndex = _index;

    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);

    ContentSplitUtil.getPageConfig(
        sourceConfig: config,
        contentWidth: constraints.maxWidth,
        contentHeight: constraints.maxHeight - 300,
        textPainter: textPainter);

    content = config.pendingPartContent;

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
                Text.rich(TextSpan(children: [
                  ...ContentSplitUtil.buildTextSpanListByPageContentConfig(
                      config),
                  WidgetSpan(
                      child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(msg: '加了个点击事件');
                    },
                    child: Container(
                      width: 200,
                      height: 300,
                      color: Colors.pink,
                      alignment: Alignment.center,
                      child: Text(
                        '假装这里有个评论区，或者广告区;\r\n(可以点击)',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )),
                ])),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      '页码:$_index',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      '页码:$_index (在右上角)',
                      style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget buildTestContentItem(BoxConstraints constraints, int _index) {
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
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      '页码:$_index (在右上角)',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ],
            ),
          ),
        ));
  }
}
