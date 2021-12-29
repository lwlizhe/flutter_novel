import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_project/item/split/content_split_util.dart';
import 'package:test_project/item/split/entity/content_split_entity.dart';
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

  Future<ChapterInfo> parseChapter({
    required String chapterContent,
    required double contentHeight,
    required double contentWidth,
    required double fontSize,
    required double lineHeight,
    double paragraphSpacing = 0,
    int currentIndex = 0,
  }) async {
    return await ContentSplitUtil.calculateChapter(
        chapterContent: chapterContent,
        contentHeight: contentHeight,
        contentWidth: contentWidth,
        fontSize: fontSize,
        lineHeight: lineHeight);
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
                        return FutureBuilder<ChapterInfo>(
                          future: parseChapter(
                            chapterContent: snapshot.data!,
                            contentHeight: constraints.maxHeight - 300,
                            contentWidth: constraints.maxWidth,
                            fontSize: 16.0,
                            lineHeight: 32.0,
                          ),
                          builder: (BuildContext context,
                              AsyncSnapshot<ChapterInfo> snapshot) {
                            if (!snapshot.hasData) {
                              return Text('loading');
                            }

                            controller = PowerListScrollSimulationController(
                                initialScrollOffset:
                                    MediaQuery.of(context).size.width);
                            return PowerListView.builder(
                              physics: PageScrollPhysics(),
                              controller: controller,
                              // controller: PowerListScrollController(),
                              addRepaintBoundaries: false,
                              scrollDirection: Axis.horizontal,
                              // layoutManager: PowerListCoverLayoutManager(),
                              layoutManager:
                                  PowerListSimulationTurnLayoutManager(),
                              itemBuilder: (BuildContext context, int _index) {
                                var controller =
                                    PowerListScrollSimulationController();
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                          child: PowerListView.builder(
                                        physics: PageScrollPhysics(),
                                        controller: controller,
                                        // controller: PowerListScrollController(),
                                        addRepaintBoundaries: false,
                                        scrollDirection: Axis.horizontal,
                                        // layoutManager: PowerListCoverLayoutManager(),
                                        layoutManager:
                                            PowerListSimulationTurnLayoutManager(),
                                        itemBuilder:
                                            (BuildContext context, int _index) {
                                          return buildContentItem(constraints,
                                              _index, snapshot.data!);
                                          // return buildTestContentItem(constraints, _index);
                                        },
                                        itemCount: snapshot.data!
                                            .chapterPageContentList.length,
                                      )),
                                      Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Text(
                                              '当前章节index为$_index,章节内共有${snapshot.data!.chapterPageContentList.length}页')),
                                    ],
                                  ),
                                );

                                // return buildContentItem(constraints, _index);
                                // return buildTestContentItem(constraints, _index);
                              },
                              itemCount: 3,
                            );
                          },
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

  Widget buildContentItem(
      BoxConstraints constraints, int _index, ChapterInfo sourceConfig) {
    // ReaderChapterPageContentConfig config = ReaderChapterPageContentConfig();
    // config.paragraphContents = [];
    // config.currentContentFontSize = 16;
    // config.currentContentLineHeight = 32;
    // config.currentContentParagraphSpacing = 0;
    // config.currentPageIndex = _index;
    //
    // TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    //
    // ContentSplitUtil.getPageConfig(
    //     sourceConfig: config,
    //     contentWidth: constraints.maxWidth,
    //     contentHeight: constraints.maxHeight - 300,
    //     textPainter: textPainter);

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
                      sourceConfig.chapterPageContentList[_index]),
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
