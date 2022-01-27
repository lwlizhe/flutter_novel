import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/common/util.dart';
import 'package:flutter_novel/novel/viewmodel/novel_reader_view_model.dart';
import 'package:flutter_novel/reader/novel_reader_list.dart';

/// --------------------------- 小说阅读阅读器页面 ------------------------------
class NovelReaderPage extends BaseView<NovelReaderViewModel> {
  final String novelId;

  NovelReaderPage(this.novelId);

  @override
  Widget buildContent(BuildContext context, NovelReaderViewModel viewModel) {
    return Scaffold(
      body: _NovelReaderPageContent(),
    );
  }

  @override
  NovelReaderViewModel buildViewModel() {
    return NovelReaderViewModel();
  }

  @override
  String? get tag => novelId;
}

/// --------------------------- 小说阅读阅读器页面（主体） ------------------------------
class _NovelReaderPageContent extends StatefulWidget {
  const _NovelReaderPageContent({Key? key}) : super(key: key);

  @override
  _NovelReaderPageContentState createState() => _NovelReaderPageContentState();
}

class _NovelReaderPageContentState extends State<_NovelReaderPageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimationController;
  late Animation<Offset> menuTopAnimationProgress;
  late Animation<Offset> menuBottomAnimationProgress;

  final GlobalKey _ignorePointerKey = GlobalKey();
  bool _shouldIgnorePointer = false;

  @override
  void initState() {
    super.initState();
    menuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    menuTopAnimationProgress = menuAnimationController
        .drive(Tween(begin: Offset(0.0, -1.0), end: Offset.zero));
    menuBottomAnimationProgress = menuAnimationController
        .drive(Tween(begin: Offset(0.0, 1.0), end: Offset.zero));

    menuAnimationController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        setIgnorePointer(true);
      } else {
        setIgnorePointer(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (menuAnimationController.isCompleted) {
                menuAnimationController.reverse();
              } else {
                menuAnimationController.forward();
              }
            },
            child: IgnorePointer(
              key: _ignorePointerKey,
              ignoring: _shouldIgnorePointer,
              ignoringSemantics: false,
              child: _NovelReaderPageReaderContent(),
            ),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: menuTopAnimationProgress,
              child: _NovelReaderPageMenuTop(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: menuBottomAnimationProgress,
              child: _NovelReaderPageMenuBottom(),
            ),
          ),
        ],
      ),
    );
  }

  void setIgnorePointer(bool value) {
    if (_shouldIgnorePointer == value) return;
    _shouldIgnorePointer = value;
    if (_ignorePointerKey.currentContext != null) {
      final RenderIgnorePointer renderBox = _ignorePointerKey.currentContext!
          .findRenderObject()! as RenderIgnorePointer;
      renderBox.ignoring = _shouldIgnorePointer;
    }
  }
}

/// --------------------------- 阅读器页面内容部分 ------------------------------
class _NovelReaderPageReaderContent extends StatelessWidget {
  const _NovelReaderPageReaderContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NovelReaderListPage();
  }
}

/// -------------------------- 阅读器页面菜单（顶部） -----------------------------
class _NovelReaderPageMenuTop extends StatefulWidget {
  const _NovelReaderPageMenuTop({Key? key}) : super(key: key);

  @override
  _NovelReaderPageMenuTopState createState() => _NovelReaderPageMenuTopState();
}

class _NovelReaderPageMenuTopState extends State<_NovelReaderPageMenuTop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AppBar(),
    );
  }
}

/// -------------------------- 阅读器页面菜单（底部） -----------------------------
class _NovelReaderPageMenuBottom extends StatefulWidget {
  const _NovelReaderPageMenuBottom({Key? key}) : super(key: key);

  @override
  _NovelReaderPageMenuBottomState createState() =>
      _NovelReaderPageMenuBottomState();
}

class _NovelReaderPageMenuBottomState
    extends State<_NovelReaderPageMenuBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              buildButton(
                  context: context,
                  onPressCallback: () {},
                  childWidgetBuilder: (context) {
                    return Padding(
                      padding: EdgeInsetsDirectional.all(16),
                      child: Text(
                        '上一章',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    );
                  }),
              Expanded(child: Container()),
              buildButton(
                  context: context,
                  onPressCallback: () {},
                  childWidgetBuilder: (context) {
                    return Padding(
                      padding: EdgeInsetsDirectional.all(16),
                      child: Text(
                        '下一章',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    );
                  }),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton(
                    context: context,
                    onPressCallback: () {},
                    childWidgetBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '目录',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                buildButton(
                    context: context,
                    onPressCallback: () {},
                    childWidgetBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '选项',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                buildButton(
                    context: context,
                    onPressCallback: () {},
                    childWidgetBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '亮度',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                buildButton(
                    context: context,
                    onPressCallback: () {},
                    childWidgetBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '阅读模式',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
                buildButton(
                    context: context,
                    onPressCallback: () {},
                    childWidgetBuilder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          '更多',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
