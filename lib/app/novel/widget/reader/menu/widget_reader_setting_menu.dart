import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/cache/novel_config_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/widget/reader/manager/manager_reader_progress.dart';
import 'package:flutter_novel/app/novel/widget/reader/menu/manager_menu_widget.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/base/util/utils_toast.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

class NovelSettingMenu extends StatelessWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  NovelSettingMenu(this._menuItemClickedCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _SettingMenuScreenBrightItem(),
              _SettingMenuFontSizeItem(_menuItemClickedCallback),
              _SettingMenuLineHeightItem(_menuItemClickedCallback),
              _SettingMenuParagraphSpacingItem(_menuItemClickedCallback),
              _SettingMenuAnimationStyleItem(_menuItemClickedCallback),
              _SettingMenuPageBgItem(_menuItemClickedCallback),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingMenuScreenBrightItem extends StatefulWidget {
  @override
  __SettingMenuScreenBrightItemState createState() =>
      __SettingMenuScreenBrightItemState();
}

class __SettingMenuScreenBrightItemState
    extends State<_SettingMenuScreenBrightItem> {
  /// 因为不同机型上有不同的max brightness值，比如说小米cc9 上亮度最大值是超过255的，不是标准的谷歌标准，所以这块采用默认0.2，然后用户设置保存到数据库中，每回打开的时候设置一遍用户数据
  double _currentScreenBrightness = 0.2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Row(
        children: <Widget>[
          Padding(
            child: Icon(
              Icons.brightness_low,
              color: Colors.grey,
              size: 24,
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Slider(
                value: _currentScreenBrightness == null
                    ? 0
                    : _currentScreenBrightness,
                onChanged: (value) {
                  setState(() {
                    _currentScreenBrightness = value;
                    Screen.setBrightness(value);
                    NovelConfigManager().setUserBrightnessConfig(value);
                  });
                },
              ),
            ),
            flex: 1,
          ),
          Padding(
            child: Icon(
              Icons.brightness_high,
              color: Colors.grey,
              size: 24,
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ],
      ),
    );
  }
}

class _SettingMenuFontSizeItem extends StatefulWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  _SettingMenuFontSizeItem(this._menuItemClickedCallback);

  @override
  State<StatefulWidget> createState() {
    return _SettingMenuFontSizeState();
  }
}

class _SettingMenuFontSizeState extends State<_SettingMenuFontSizeItem> {
  int currentFontSize;

  @override
  void initState() {
    super.initState();

    NovelConfigManager().getUserFontSizeConfig().then((value) {
      setState(() {
        currentFontSize = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    NovelReaderViewModel viewModel =
        Provider.of<NovelReaderViewModel>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text(
                  "Aa-",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )),
            onTap: () async {
              if (currentFontSize != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setFontSize(currentFontSize - 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          Text(
            currentFontSize == null ? "正在查询" : "$currentFontSize",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "Aa+",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            onTap: () async {
              if (currentFontSize != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setFontSize(currentFontSize + 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          InkWell(
            child: Container(
              width: 55,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "默认",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            onTap: () {
              if (currentFontSize != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setFontSize(NovelConfigManager.VALUE_DEFAULT_FONT_SIZE);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _setFontSize(int targetSize) {
    NovelConfigManager().setUserFontSizeConfig(targetSize);
    widget._menuItemClickedCallback(
        MenuOperateEnum.OPERATE_SETTING_FONT_SIZE, targetSize);
    setState(() {
      currentFontSize = targetSize;
    });
  }
}

class _SettingMenuLineHeightItem extends StatefulWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  _SettingMenuLineHeightItem(this._menuItemClickedCallback);

  @override
  State<StatefulWidget> createState() {
    return _SettingMenuLineHeightState();
  }
}

class _SettingMenuLineHeightState extends State<_SettingMenuLineHeightItem> {
  int currentLineHeight;

  @override
  void initState() {
    super.initState();

    NovelConfigManager().getUserLineHeightConfig().then((value) {
      setState(() {
        currentLineHeight = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    NovelReaderViewModel viewModel =
        Provider.of<NovelReaderViewModel>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text(
                  "行高-",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )),
            onTap: () async {
              if (currentLineHeight != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setLineHeight(currentLineHeight - 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          Text(
            currentLineHeight == null ? "正在查询" : "$currentLineHeight",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "行高+",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            onTap: () async {
              if (currentLineHeight != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setLineHeight(currentLineHeight + 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          InkWell(
            child: Container(
              width: 55,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "默认",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            onTap: () {
              if (currentLineHeight != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setLineHeight(NovelConfigManager.VALUE_DEFAULT_LINE_HEIGHT);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _setLineHeight(int targetHeight) {
    NovelConfigManager().setUserLineHeightConfig(targetHeight);
    widget._menuItemClickedCallback(
        MenuOperateEnum.OPERATE_SETTING_LINE_HEIGHT, targetHeight);
    setState(() {
      currentLineHeight = targetHeight;
    });
  }
}

class _SettingMenuParagraphSpacingItem extends StatefulWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  _SettingMenuParagraphSpacingItem(this._menuItemClickedCallback);

  @override
  State<StatefulWidget> createState() {
    return _SettingMenuParagraphSpacingState();
  }
}

class _SettingMenuParagraphSpacingState extends State<_SettingMenuParagraphSpacingItem> {
  int currentParagraphSpacing;

  @override
  void initState() {
    super.initState();

    NovelConfigManager().getUserParagraphSpacingConfig().then((value) {
      setState(() {
        currentParagraphSpacing = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    NovelReaderViewModel viewModel =
        Provider.of<NovelReaderViewModel>(context, listen: false);

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text(
                  "段落间距-",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )),
            onTap: () async {
              if (currentParagraphSpacing != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setParagraphSpacing(currentParagraphSpacing - 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          Text(
            currentParagraphSpacing == null ? "正在查询" : "$currentParagraphSpacing",
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "段落间距+",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            onTap: () async {
              if (currentParagraphSpacing != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setParagraphSpacing(currentParagraphSpacing + 1);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
          InkWell(
            child: Container(
              width: 55,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey, width: 1.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "默认",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            onTap: () {
              if (currentParagraphSpacing != null) {
                if (viewModel.getCurrentState() !=
                    ReaderProgressStateEnum.STATE_LOADING) {
                  _setParagraphSpacing(NovelConfigManager.VALUE_DEFAULT_PARAGRAPH_SPACING);
                } else {
                  ToastUtils.showToast("正在测量中，请稍后");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _setParagraphSpacing(int targetSpacing) {
    NovelConfigManager().setUserParagraphSpacingConfig(targetSpacing);
    widget._menuItemClickedCallback(
        MenuOperateEnum.OPERATE_SETTING_PARAGRAPH_SPACING, targetSpacing);
    setState(() {
      currentParagraphSpacing = targetSpacing;
    });
  }
}

class _SettingMenuAnimationStyleItem extends StatefulWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  _SettingMenuAnimationStyleItem(this._menuItemClickedCallback);

  @override
  State<StatefulWidget> createState() {
    return _SettingMenuAnimationStyleState();
  }
}

class _SettingMenuAnimationStyleState
    extends State<_SettingMenuAnimationStyleItem> {
  int currentAnimationMode;

  @override
  void initState() {
    super.initState();

    NovelConfigManager().getUserConfigAnimationMode().then((value) {
      setState(() {
        currentAnimationMode = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: currentAnimationMode ==
                              ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN
                          ? Colors.orange
                          : Colors.grey,
                      width: 1.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Text(
                  "仿真",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )),
            onTap: () {
              if (currentAnimationMode != null &&
                  currentAnimationMode !=
                      ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN) {
                NovelConfigManager().setUserConfigAnimationMode(
                    ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN);
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_ANIMATION_MODE,
                    ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN);
                setState(() {
                  currentAnimationMode =
                      ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN;
                });
              }
            },
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: currentAnimationMode ==
                            ReaderPageManager.TYPE_ANIMATION_COVER_TURN
                        ? Colors.orange
                        : Colors.grey,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "覆盖",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            onTap: () {
              if (currentAnimationMode != null &&
                  currentAnimationMode !=
                      ReaderPageManager.TYPE_ANIMATION_COVER_TURN) {
                NovelConfigManager().setUserConfigAnimationMode(
                    ReaderPageManager.TYPE_ANIMATION_COVER_TURN);
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_ANIMATION_MODE,
                    ReaderPageManager.TYPE_ANIMATION_COVER_TURN);
                setState(() {
                  currentAnimationMode =
                      ReaderPageManager.TYPE_ANIMATION_COVER_TURN;
                });
              }
            },
          ),
          InkWell(
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: currentAnimationMode ==
                            ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN
                        ? Colors.orange
                        : Colors.grey,
                    width: 1.0,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Text(
                "滚动",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            onTap: () {
              if (currentAnimationMode != null &&
                  currentAnimationMode !=
                      ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN) {
                NovelConfigManager().setUserConfigAnimationMode(
                    ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN);
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_ANIMATION_MODE,
                    ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN);
                setState(() {
                  currentAnimationMode =
                      ReaderPageManager.TYPE_ANIMATION_SLIDE_TURN;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SettingMenuPageBgItem extends StatefulWidget {
  final OnMenuItemClicked _menuItemClickedCallback;

  _SettingMenuPageBgItem(this._menuItemClickedCallback);

  @override
  State<StatefulWidget> createState() {
    return _SettingMenuPageBgItemState();
  }
}

class _SettingMenuPageBgItemState extends State<_SettingMenuPageBgItem> {
  Color selectedBgColor;

  @override
  void initState() {
    super.initState();
    NovelConfigManager().getUserConfigBgColor().then((value) {
      setState(() {
        selectedBgColor = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Color(0xfffff2cc).value == selectedBgColor?.value
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 50,
                        alignment: Alignment.center,
                        color: Color(0xfffff2cc),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.red,
                      )
                    ],
                  )
                : Container(
                    width: 60,
                    height: 50,
                    alignment: Alignment.center,
                    color: Color(0xfffff2cc),
                  ),
            onTap: () {
              if (selectedBgColor != null &&
                  selectedBgColor != Color(0xfffff2cc)) {
                NovelConfigManager().setUserConfigBgColor(Color(0xfffff2cc));
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_BG_COLOR,
                    Color(0xfffff2cc));
                setState(() {
                  selectedBgColor = Color(0xfffff2cc);
                });
              }
            },
          ),
          InkWell(
            child: Colors.greenAccent.value == selectedBgColor?.value
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.greenAccent,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.red,
                      )
                    ],
                  )
                : Container(
                    width: 60,
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.greenAccent,
                  ),
            onTap: () {
              if (selectedBgColor != null &&
                  selectedBgColor != Colors.greenAccent) {
                NovelConfigManager().setUserConfigBgColor(Colors.greenAccent);
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_BG_COLOR,
                    Colors.greenAccent);
                setState(() {
                  selectedBgColor = Colors.greenAccent;
                });
              }
            },
          ),
          InkWell(
            child: Colors.grey.value == selectedBgColor?.value
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.red,
                      )
                    ],
                  )
                : Container(
                    width: 60,
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.grey,
                  ),
            onTap: () {
              if (selectedBgColor != null &&
                  selectedBgColor != Colors.grey) {
                NovelConfigManager().setUserConfigBgColor(Colors.grey);
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_BG_COLOR,
                    Colors.grey);
                setState(() {
                  selectedBgColor = Colors.grey;
                });
              }
            },
          ),
          InkWell(
            child: Color(0xfffafafa).value == selectedBgColor?.value
                ? Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 50,
                        alignment: Alignment.center,
                        color: Color(0xfffafafa),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.red,
                      )
                    ],
                  )
                : Container(
                    width: 60,
                    height: 50,
                    alignment: Alignment.center,
                    color: Color(0xfffafafa),
                  ),
            onTap: () {
              if (selectedBgColor != null &&
                  selectedBgColor != Color(0xfffafafa)) {
                NovelConfigManager().setUserConfigBgColor(Color(0xfffafafa));
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SETTING_BG_COLOR,
                    Color(0xfffafafa));
                setState(() {
                  selectedBgColor = Color(0xfffafafa);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
