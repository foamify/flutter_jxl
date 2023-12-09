import 'dart:math';

import 'package:vector_math/vector_math.dart';

const GAMMA = 2.4;
const OFFSET = 0.055;

// moncurve_r with gamma of 2.4 and offset of 0.055 matches the EOTF found in IEC 61966-2-1:1999 (sRGB)
double moncurve_f(double x, double gamma, double offs) {
  double fs = ((gamma - 1.0) / offs) *
      pow(offs * gamma / ((gamma - 1.0) * (1.0 + offs)), gamma);
  double xb = offs / (gamma - 1.0);
  return x >= xb ? pow((x + offs) / (1.0 + offs), gamma).toDouble() : x * fs;
}

Vector3 transferSrgbInverse(Vector3 color) {
  return Vector3(
    moncurve_f(color.x, GAMMA, OFFSET),
    moncurve_f(color.y, GAMMA, OFFSET),
    moncurve_f(color.z, GAMMA, OFFSET),
  );
}
