import 'dart:math' as math;

const double XYZ_WHITE_REFERENCE_X = 95.047;
const double XYZ_WHITE_REFERENCE_Y = 100;
const double XYZ_WHITE_REFERENCE_Z = 108.883;
const double XYZ_EPSILON = 0.008856;
const double XYZ_KAPPA = 903.3;

const int MIN_ALPHA_SEARCH_MAX_ITERATIONS = 10;
const int MIN_ALPHA_SEARCH_PRECISION = 1;

void RGBToHSL(int r, int g, int b, List<double> outHsl) {
  double constrain(double amount, double low, double high) {
    return amount < low ? low : (amount > high ? high : amount);
  }

  final double rf = r / 255;
  final double gf = g / 255;
  final double bf = b / 255;

  final double max = math.max(rf, math.max(gf, bf));
  final double min = math.min(rf, math.min(gf, bf));
  final double deltaMaxMin = max - min;

  double h, s;
  double l = (max + min) / 2;

  if (max == min) {
// Monochromatic
    h = s = 0;
  } else {
    if (max == rf) {
      h = ((gf - bf) / deltaMaxMin) % 6;
    } else if (max == gf) {
      h = ((bf - rf) / deltaMaxMin) + 2;
    } else {
      h = ((rf - gf) / deltaMaxMin) + 4;
    }

    s = deltaMaxMin / (1 - (2 * l - 1).abs());
  }

  h = (h * 60) % 360;
  if (h < 0) {
    h += 360;
  }

  outHsl[0] = constrain(h, 0, 360);
  outHsl[1] = constrain(s, 0, 1);
  outHsl[2] = constrain(l, 0, 1);
}

int getColorRed(int color) {
  return (color >> 16) & 0xFF;
}

int getColorGreen(int color) {
  return (color >> 8) & 0xFF;
}

int getColorBlue(int color) {
  return color & 0xFF;
}

int setAlphaComponent(int color, int alpha) {
  if (alpha < 0 || alpha > 255) {
    return 0;
  }
  return (color & 0x00ffffff) | (alpha << 24);
}
