import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_novel/common/palette/color_cut_quantizier.dart';

import '../color_util.dart';

const MIN_CONTRAST_TITLE_TEXT = 3.0;
const MIN_CONTRAST_BODY_TEXT = 4.5;

class Palette {
  Future<List<Swatch>> decodePic() async {
    final ByteData sourceByteData = await rootBundle.load("img/test3.jpeg");

    final Codec codec = await instantiateImageCodec(
        sourceByteData.buffer.asUint8List(),
        targetWidth: 164,
        targetHeight: 77);

    var frameInfo = await codec.getNextFrame();

    var byteData =
        (await frameInfo.image.toByteData(format: ImageByteFormat.rawRgba))!;

    final uint8list = Uint8List.view(byteData.buffer);
    List<int> colors = [];
    for (int j = 0, r, g, b, a; j < uint8list.length; j += 4) {
      r = uint8list[j + 0];
      g = uint8list[j + 1];
      b = uint8list[j + 2];
      a = uint8list[j + 3];
      colors.add(Color.fromARGB(a, r, g, b).value);
    }

    var quantizier =
        ColorCutQuantizer(colors, 16, [DefaultFilter()]).mQuantizedColors;
    return quantizier;
  }
}

class DefaultFilter implements Filter {
  @override
  bool isAllowed(int rgb, List<double> hsl) {
    // return true;
    return !isWhite(hsl) && !isBlack(hsl);
    // return !isWhite(hsl) && !isBlack(hsl);
  }

  static const BLACK_MAX_LIGHTNESS = 0.05;
  static const WHITE_MIN_LIGHTNESS = 0.95;

  bool isBlack(List<double> hslColor) {
    return hslColor[2] <= BLACK_MAX_LIGHTNESS;
  }

  bool isWhite(List<double> hslColor) {
    return hslColor[2] >= WHITE_MIN_LIGHTNESS;
  }

  bool isNearRedILine(List<double> hslColor) {
    return hslColor[0] >= 10.0 && hslColor[0] <= 37.0 && hslColor[1] <= 0.82;
  }
}

abstract class Filter {
  bool isAllowed(int rgb, List<double> hsl);
}

class Swatch {
  int mRed = 0, mGreen = 0, mBlue = 0;
  int mRgb = 0;
  int mPopulation = 0;

  bool mGeneratedTextColors = false;
  int mTitleTextColor = 0;
  int mBodyTextColor = 0;

  List<double>? mHsl;

  Swatch(int color, int population) {
    mRed = getColorRed(color);
    mGreen = getColorGreen(color);
    mBlue = getColorBlue(color);
    mRgb = color;
    mPopulation = population;
  }

// Swatch(int red, int green, int blue, int population) {
// mRed = red;
// mGreen = green;
// mBlue = blue;
// mRgb = Color.rgb(red, green, blue);
// mPopulation = population;
// }

// Swatch(float[] hsl, int population) {
// this(ColorUtils.HSLToColor(hsl), population);
// mHsl = hsl;
// }

  /**
   * @return this swatch's RGB color value
   */
  int getRgb() {
    return mRgb;
  }

  /**
   * Return this swatch's HSL values.
   *     hsv[0] is Hue [0 .. 360)
   *     hsv[1] is Saturation [0...1]
   *     hsv[2] is Lightness [0...1]
   */
  List<double> getHsl() {
    if (mHsl == null) {
      mHsl = List.filled(3, 0);
    }
    RGBToHSL(mRed, mGreen, mBlue, mHsl!);
    return mHsl!;
  }

  /**
   * @return the number of pixels represented by this swatch
   */
  int getPopulation() {
    return mPopulation;
  }
}
