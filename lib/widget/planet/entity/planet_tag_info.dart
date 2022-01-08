import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class PlanetTagInfo {
  Vector3 planetTagPos = Vector3(0, 0, 0);
  Widget child;
  double currentAngle = 0;
  double radius = 0;

  PlanetTagInfo({required this.planetTagPos, required this.child});

  double get opacity {
    var result = 0.9 * ((radius + planetTagPos.z) / (radius * 2)) + 0.1;
    return result.isNaN || result.isNegative ? 0.0 : result;
  }

  double get scale {
    var result = ((radius + planetTagPos.z) / (radius * 2)) * 6 / 8 + 2 / 8;
    return result.isNaN || result.isNegative ? 0.0 : result;
  }
}
