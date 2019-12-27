import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/manager_menu_widget.dart';



class NovelBottomMenu extends StatefulWidget {
  final ReaderContentDataValue dataValue;
  final OnMenuItemClicked _menuItemClickedCallback;

  NovelBottomMenu(this.dataValue, this._menuItemClickedCallback, Key key)
      : super(key: key);

  @override
  _NovelBottomMenuState createState() => _NovelBottomMenuState();
}

class _NovelBottomMenuState extends State<NovelBottomMenu> {
  double _currentPageIndex;
  double _chapterLength;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(NovelBottomMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    _currentPageIndex = widget?.dataValue?.currentPageIndex?.toDouble();
    _chapterLength =
        widget?.dataValue?.chapterContentConfigs?.length?.toDouble();

    _currentPageIndex ??= 0;
    _chapterLength ??= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
          child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Column(
          children: <Widget>[
            NovelBottomMenuChapterControllerWidget(
                widget.dataValue, widget._menuItemClickedCallback),
            NovelBottomMenuExtraFunctionWidget(widget._menuItemClickedCallback)
          ],
        ),
      )),
    );
  }
}

class NovelBottomMenuChapterControllerWidget extends StatefulWidget {
  final ReaderContentDataValue dataValue;
  final OnMenuItemClicked _menuItemClickedCallback;

  NovelBottomMenuChapterControllerWidget(
      this.dataValue, this._menuItemClickedCallback);

  @override
  _NovelBottomMenuChapterControllerState createState() =>
      _NovelBottomMenuChapterControllerState();
}

class _NovelBottomMenuChapterControllerState
    extends State<NovelBottomMenuChapterControllerWidget> {
  double _currentPageIndex;
  double _chapterLength;

  @override
  void didUpdateWidget(NovelBottomMenuChapterControllerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentPageIndex = widget?.dataValue?.currentPageIndex?.toDouble();
    _chapterLength =
        widget?.dataValue?.chapterContentConfigs?.length?.toDouble();

    _currentPageIndex ??= 0;
    _chapterLength ??= 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "上一章",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            onTap: () {
              widget._menuItemClickedCallback(
                  MenuOperateEnum.OPERATE_PRE_CHAPTER, null);
            },
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Builder(builder: (context){
                if(_chapterLength==null||_chapterLength==0||_currentPageIndex==null){
                  return Container();
                }else{
                  return Slider(
                    value: _currentPageIndex,
                    min: 0,
                    max: (_chapterLength==null?0:_chapterLength) - 1 < 0 ? 1 : _chapterLength - 1,
                    divisions: (_chapterLength?.toInt()==null?0:_chapterLength?.toInt()) - 1 <= 0
                        ? 1
                        : _chapterLength.toInt() - 1,
                    onChanged: (value) {
                      setState(() {
                        _currentPageIndex = value;
                        widget._menuItemClickedCallback(
                            MenuOperateEnum.OPERATE_JUMP_CHAPTER, value.toInt());
                      });
                    },
                  );
                }
              }),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text("下一章",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            onTap: () {
              widget._menuItemClickedCallback(
                  MenuOperateEnum.OPERATE_NEXT_CHAPTER, null);
            },
          )
        ],
      ),
    );
  }
}

class NovelBottomMenuExtraFunctionWidget extends StatelessWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  const NovelBottomMenuExtraFunctionWidget(this._menuItemClickedCallback);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 26,
                ),
                Text(
                  "目录",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            onTap: () {
              _menuItemClickedCallback(
                  MenuOperateEnum.OPERATE_OPEN_CATALOG, null);
            },
          ),
          InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.brightness_3,
                  color: Colors.grey,
                  size: 26,
                ),
                Text(
                  "夜间",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            onTap: () {
              _menuItemClickedCallback(
                  MenuOperateEnum.OPERATE_TOGGLE_NIGHT_MODE, null);
            },
          ),
          InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 26,
                ),
                Text(
                  "设置",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
            onTap: () {
              _menuItemClickedCallback(
                  MenuOperateEnum.OPERATE_OPEN_SETTING, null);
            },
          ),
        ],
      ),
    );
  }
}
