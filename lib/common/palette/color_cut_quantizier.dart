import 'dart:math' as math;

import 'package:collection/collection.dart'
    show PriorityQueue, HeapPriorityQueue;
import 'package:flutter_novel/common/palette/palette.dart';

import '../color_util.dart';

export 'dart:ui' show AppLifecycleState, VoidCallback, FrameTiming;

const LOG_TIMINGS = false;

const COMPONENT_RED = -3;
const COMPONENT_GREEN = -2;
const COMPONENT_BLUE = -1;

const QUANTIZE_WORD_WIDTH = 5;
const QUANTIZE_WORD_MASK = (1 << QUANTIZE_WORD_WIDTH) - 1;

int quantizedRed(int color) {
  return (color >> (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH)) &
      QUANTIZE_WORD_MASK;
}

int quantizedGreen(int color) {
  return (color >> QUANTIZE_WORD_WIDTH) & QUANTIZE_WORD_MASK;
}

int quantizedBlue(int color) {
  return color & QUANTIZE_WORD_MASK;
}

int quantizeFromRgb888(int color) {
  int r = modifyWordWidth(getColorRed(color), 8, QUANTIZE_WORD_WIDTH);
  int g = modifyWordWidth(getColorGreen(color), 8, QUANTIZE_WORD_WIDTH);
  int b = modifyWordWidth(getColorBlue(color), 8, QUANTIZE_WORD_WIDTH);
  return r << (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH) |
      g << QUANTIZE_WORD_WIDTH |
      b;
}

int approximateToRgb888OfRGB(int r, int g, int b) {
  return 0xff000000 |
      (modifyWordWidth(r, QUANTIZE_WORD_WIDTH, 8) << 16) |
      (modifyWordWidth(g, QUANTIZE_WORD_WIDTH, 8) << 8) |
      modifyWordWidth(b, QUANTIZE_WORD_WIDTH, 8);
}

int approximateToRgb888OfColor(int color) {
  return approximateToRgb888OfRGB(
      quantizedRed(color), quantizedGreen(color), quantizedBlue(color));
}

int modifyWordWidth(int value, int currentWidth, int targetWidth) {
  final int newValue;
  if (targetWidth > currentWidth) {
// If we're approximating up in word width, we'll shift up
    newValue = value << (targetWidth - currentWidth);
  } else {
// Else, we will just shift and keep the MSB
    newValue = value >> (currentWidth - targetWidth);
  }
  return newValue & ((1 << targetWidth) - 1);
}

class ColorCutQuantizer {
  static List<int> mColors = [];
  static List<int> mHistogram = [];

  final List<Swatch> mQuantizedColors = [];

  // final TimingLogger mTimingLogger;
  final List<Filter> mFilters = [];

  final List<double> mTempHsl = List.filled(3, 0);

  ColorCutQuantizer(
      final List<int> pixels, final int maxColors, final List<Filter> filters) {
    mFilters.clear();
    mFilters.addAll(filters);

    final List<int> hist =
        mHistogram = List.filled(1 << (QUANTIZE_WORD_WIDTH * 3), 0);
    for (int i = 0; i < pixels.length; i++) {
      final int quantizedColor = quantizeFromRgb888(pixels[i]);
      // Now update the pixel value to the quantized value
      pixels[i] = quantizedColor;
      // And update the histogram
      hist[quantizedColor]++;
    }

    // Now let's count the number of distinct colors
    int distinctColorCount = 0;
    for (int color = 0; color < hist.length; color++) {
      if (hist[color] > 0 && shouldIgnoreColorOfColor(color)) {
        // If we should ignore the color, set the population to 0
        hist[color] = 0;
      }
      if (hist[color] > 0) {
        // If the color has population, increase the distinct color count
        distinctColorCount++;
      }
    }

    // Now lets go through create an array consisting of only distinct colors
    mColors = List.filled(distinctColorCount, 0, growable: true);
    int distinctColorIndex = 0;
    for (int color = 0; color < hist.length; color++) {
      if (hist[color] > 0) {
        mColors[distinctColorIndex++] = color;
      }
    }

    if (distinctColorCount <= maxColors) {
      // The image has fewer colors than the maximum requested, so just return the colors
      mQuantizedColors.clear();
      for (int color in mColors) {
        mQuantizedColors
            .add(Swatch(approximateToRgb888OfColor(color), hist[color]));
      }
    } else {
      // We need use quantization to reduce the number of colors

      mQuantizedColors.clear();
      mQuantizedColors.addAll(quantizePixels(maxColors));
    }
  }

  List<Swatch> quantizePixels(int maxColors) {
    // Create the priority queue which is sorted by volume descending. This means we always
    // split the largest box in the queue

    final PriorityQueue<VBox> pq = PriorityQueue<VBox>((lhs, rhs) {
      return rhs.getVolume() - lhs.getVolume();
    });

    // To start, offer a box which contains all of the colors
    pq.add(VBox(0, mColors.length - 1));

    // Now go through the boxes, splitting them until we have reached maxColors or there are no
    // more boxes to split
    splitBoxes(pq, maxColors);

    // Finally, return the average colors of the color boxes
    return generateAverageColors(pq);
  }

  void splitBoxes(final PriorityQueue<VBox> queue, final int maxSize) {
    while (queue.length < maxSize && queue.isNotEmpty) {
      final VBox vbox = queue.removeFirst();

      if (vbox.canSplit()) {
        // First split the box, and offer the result
        var splitBox = vbox.splitBox();
        if (splitBox != null) {
          queue.add(splitBox);
        }
        // Then offer the box back
        queue.add(vbox);
      } else {
        // If we get here then there are no more boxes to split, so return
        return;
      }
    }
  }

  List<Swatch> generateAverageColors(PriorityQueue<VBox> vboxes) {
    List<Swatch> colors = List.empty(growable: true);
    var boxList = vboxes.toList();
    for (VBox vbox in boxList) {
      Swatch swatch = vbox.getAverageColor();
      if (!shouldIgnoreColorOfSwatch(swatch)) {
        // As we're averaging a color box, we can still get colors which we do not want, so
        // we check again here
        colors.add(swatch);
      }
    }
    return colors;
  }

  static void modifySignificantOctet(final List<int> a, final int dimension,
      final int lower, final int upper) {
    switch (dimension) {
      case COMPONENT_RED:
        // Already in RGB, no need to do anything
        break;
      case COMPONENT_GREEN:
        // We need to do a RGB to GRB swap, or vice-versa
        for (int i = lower; i <= upper; i++) {
          final int color = a[i];
          a[i] = quantizedGreen(color) <<
                  (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH) |
              quantizedRed(color) << QUANTIZE_WORD_WIDTH |
              quantizedBlue(color);
        }
        break;
      case COMPONENT_BLUE:
        // We need to do a RGB to BGR swap, or vice-versa
        for (int i = lower; i <= upper; i++) {
          final int color = a[i];
          a[i] = quantizedBlue(color) <<
                  (QUANTIZE_WORD_WIDTH + QUANTIZE_WORD_WIDTH) |
              quantizedGreen(color) << QUANTIZE_WORD_WIDTH |
              quantizedRed(color);
        }
        break;
    }
  }

  bool shouldIgnoreColorOfColor(int color565) {
    final int rgb = approximateToRgb888OfColor(color565);
    RGBToHSL(getColorRed(color565), getColorGreen(color565),
        getColorBlue(color565), mTempHsl);
    return shouldIgnoreColor(rgb, mTempHsl);
  }

  bool shouldIgnoreColorOfSwatch(Swatch color) {
    return shouldIgnoreColor(color.getRgb(), color.getHsl());
  }

  bool shouldIgnoreColor(int rgb, List<double> hsl) {
    if (mFilters.length > 0) {
      for (int i = 0, count = mFilters.length; i < count; i++) {
        if (!mFilters[i].isAllowed(rgb, hsl)) {
          return true;
        }
      }
    }
    return false;
  }
}

class VBox {
  int lowerIndex = 0;
  int upperIndex = 0;

  int population = 0;

  int minRed = 0, maxRed = 0;
  int minGreen = 0, maxGreen = 0;
  int minBlue = 0, maxBlue = 0;

  VBox(int lowerIndex, int upperIndex) {
    this.lowerIndex = lowerIndex;
    this.upperIndex = upperIndex;
    fitBox();
  }

  int getVolume() {
    return (maxRed - minRed + 1) *
        (maxGreen - minGreen + 1) *
        (maxBlue - minBlue + 1);
  }

  bool canSplit() {
    return getColorCount() > 1;
  }

  int getColorCount() {
    return 1 + upperIndex - lowerIndex;
  }

  void fitBox() {
    // final List<int> colors = ColorCutQuantizer.mColors;
    // final List<int> hist = ColorCutQuantizer.mHistogram;

    // Reset the min and max to opposite values
    int minRed, minGreen, minBlue;
    minRed = minGreen = minBlue = double.maxFinite.toInt();
    int maxRed, maxGreen, maxBlue;
    maxRed = maxGreen = maxBlue = double.minPositive.toInt();
    int count = 0;

    for (int i = lowerIndex; i <= upperIndex; i++) {
      final int color = ColorCutQuantizer.mColors[i];
      count += ColorCutQuantizer.mHistogram[color];

      final int r = quantizedRed(color);
      final int g = quantizedGreen(color);
      final int b = quantizedBlue(color);
      if (r > maxRed) {
        maxRed = r;
      }
      if (r < minRed) {
        minRed = r;
      }
      if (g > maxGreen) {
        maxGreen = g;
      }
      if (g < minGreen) {
        minGreen = g;
      }
      if (b > maxBlue) {
        maxBlue = b;
      }
      if (b < minBlue) {
        minBlue = b;
      }
    }

    this.minRed = minRed;
    this.maxRed = maxRed;
    this.minGreen = minGreen;
    this.maxGreen = maxGreen;
    this.minBlue = minBlue;
    this.maxBlue = maxBlue;
    population = count;
  }

  VBox? splitBox() {
    if (!canSplit()) {
      return null;
    }

    // find median along the longest dimension
    final int splitPoint = findSplitPoint();

    VBox newBox = new VBox(splitPoint + 1, upperIndex);

    // Now change this box's upperIndex and recompute the color boundaries
    upperIndex = splitPoint;
    fitBox();

    return newBox;
  }

  int getLongestColorDimension() {
    final int redLength = maxRed - minRed;
    final int greenLength = maxGreen - minGreen;
    final int blueLength = maxBlue - minBlue;

    if (redLength >= greenLength && redLength >= blueLength) {
      return COMPONENT_RED;
    } else if (greenLength >= redLength && greenLength >= blueLength) {
      return COMPONENT_GREEN;
    } else {
      return COMPONENT_BLUE;
    }
  }

  int findSplitPoint() {
    final int longestDimension = getLongestColorDimension();

    // We need to sort the colors in this box based on the longest color dimension.
    // As we can't use a Comparator to define the sort logic, we modify each color so that
    // its most significant is the desired dimension
    ColorCutQuantizer.modifySignificantOctet(
        ColorCutQuantizer.mColors, longestDimension, lowerIndex, upperIndex);

    // Now sort... Arrays.sort uses a exclusive toIndex so we need to add 1
    // Arrays.sort(colors, lowerIndex, upperIndex + 1);
    var replaceArray = List<int>.from(
        ColorCutQuantizer.mColors.getRange(lowerIndex, upperIndex),
        growable: true);
    replaceArray.sort();
    ColorCutQuantizer.mColors
        .replaceRange(lowerIndex, upperIndex, replaceArray);

    // Now revert all of the colors so that they are packed as RGB again
    ColorCutQuantizer.modifySignificantOctet(
        ColorCutQuantizer.mColors, longestDimension, lowerIndex, upperIndex);

    final int midPoint = population ~/ 2;
    for (int i = lowerIndex, count = 0; i <= upperIndex; i++) {
      count += ColorCutQuantizer.mHistogram[ColorCutQuantizer.mColors[i]];
      if (count >= midPoint) {
        // we never want to split on the upperIndex, as this will result in the same
        // box
        return math.min(upperIndex - 1, i);
      }
    }

    return lowerIndex;
  }

  Swatch getAverageColor() {
    int redSum = 0;
    int greenSum = 0;
    int blueSum = 0;
    int totalPopulation = 0;

    for (int i = lowerIndex; i <= upperIndex; i++) {
      final int color = ColorCutQuantizer.mColors[i];
      final int colorPopulation = ColorCutQuantizer.mHistogram[color];

      totalPopulation += colorPopulation;
      redSum += colorPopulation * quantizedRed(color);
      greenSum += colorPopulation * quantizedGreen(color);
      blueSum += colorPopulation * quantizedBlue(color);
    }

    final int redMean = (redSum / totalPopulation).round();
    final int greenMean = (greenSum / totalPopulation).round();
    final int blueMean = (blueSum / totalPopulation).round();

    return Swatch(approximateToRgb888OfRGB(redMean, greenMean, blueMean),
        totalPopulation);
  }
}
