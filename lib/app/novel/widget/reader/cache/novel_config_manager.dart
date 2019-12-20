import 'dart:ui';

import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovelConfigManager {
  static const String KEY_CONFIG_BRIGHTNESS = "key_config_brightness";
  static const String KEY_CONFIG_FONT_SIZE = "key_config_font_size";
  static const String KEY_CONFIG_LINE_HEIGHT = "key_config_line_height";
  static const String KEY_CONFIG_PARAGRAPH_SPACING = "key_config_paragraph_spacing";
  static const String KEY_CONFIG_ANIMATION_MODE = "key_config_animation_mode";
  static const String KEY_CONFIG_BG_COLOR = "key_config_bg_color";
  static const String KEY_CONFIG_LAST_READ_INFO = "key_config_last_read_info";

  static const double VALUE_DEFAULT_CONFIG_BRIGHTNESS = 0.2;

  static const int VALUE_DEFAULT_FONT_SIZE = 20;
  static const int VALUE_DEFAULT_LINE_HEIGHT = 30;
  static const int VALUE_DEFAULT_PARAGRAPH_SPACING = 10;

  static NovelConfigManager _instance;

  double brightness;
  int fontSize;
  int lineHeight;
  int paragraphSpacing;
  int animationMode;
  Color bgColor;

  factory NovelConfigManager() {
    if (_instance == null) {
      _instance = new NovelConfigManager._();
    }
    return _instance;
  }

  NovelConfigManager._() {
    getUserBrightnessConfig().then((value) {
      brightness = value;
    });
    getUserFontSizeConfig().then((value) {
      fontSize = value;
    });
    getUserConfigAnimationMode().then((value) {
      animationMode = value;
    });
  }

  Future<double> getUserBrightnessConfig() async {
    if (brightness == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      brightness = prefs.getDouble(KEY_CONFIG_BRIGHTNESS);
      brightness ??= VALUE_DEFAULT_CONFIG_BRIGHTNESS;
    }
    return brightness;
  }

  void setUserBrightnessConfig(double data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(KEY_CONFIG_BRIGHTNESS, data).then((value){
      brightness = data;
    });
  }

  Future<int> getUserFontSizeConfig() async {
    if(fontSize==null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      fontSize = prefs.getInt(KEY_CONFIG_FONT_SIZE);
      fontSize ??= VALUE_DEFAULT_FONT_SIZE;
    }
    return fontSize;
  }

  void setUserFontSizeConfig(int size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_CONFIG_FONT_SIZE, size).then((value){
      fontSize=size;
    });
  }

  Future<int> getUserLineHeightConfig() async {
    if(lineHeight==null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      lineHeight = prefs.getInt(KEY_CONFIG_LINE_HEIGHT);
      lineHeight ??= VALUE_DEFAULT_LINE_HEIGHT;
    }
    return lineHeight;
  }

  void setUserLineHeightConfig(int height) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_CONFIG_LINE_HEIGHT, height).then((value){
      lineHeight=height;
    });
  }

  Future<int> getUserParagraphSpacingConfig() async {
    if(paragraphSpacing==null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      paragraphSpacing = prefs.getInt(KEY_CONFIG_PARAGRAPH_SPACING);
      paragraphSpacing ??= VALUE_DEFAULT_PARAGRAPH_SPACING;
    }
    return paragraphSpacing;
  }

  void setUserParagraphSpacingConfig(int spacing) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_CONFIG_PARAGRAPH_SPACING, spacing).then((value){
      paragraphSpacing=spacing;
    });
  }

  Future<int> getUserConfigAnimationMode() async {
    if(animationMode==null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      animationMode = prefs.getInt(KEY_CONFIG_ANIMATION_MODE);
      animationMode??=ReaderPageManager.TYPE_ANIMATION_SIMULATION_TURN;
    }

    return animationMode;
  }

  void setUserConfigAnimationMode(int mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_CONFIG_ANIMATION_MODE, mode).then((value){
      animationMode=mode;
    });
  }

  Future<Color> getUserConfigBgColor() async {
    if(bgColor==null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int color=prefs.getInt(KEY_CONFIG_BG_COLOR);
      color??=0xfffff2cc;
      bgColor=Color(color);
    }

    return bgColor;
  }

  void setUserConfigBgColor(Color bgColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_CONFIG_BG_COLOR, bgColor.value).then((value){
      this.bgColor=bgColor;
    });
  }

  Future<String> getLastReadNovelInfoJson() async {
    String infoJson = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    infoJson = prefs.getString(KEY_CONFIG_LAST_READ_INFO);

    return infoJson;
  }

  void setLastReadNovelInfoJson(String dataJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_CONFIG_LAST_READ_INFO, dataJson);
  }
}
