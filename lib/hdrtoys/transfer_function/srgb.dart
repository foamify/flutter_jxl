import 'dart:math';

import 'package:vector_math/vector_math.dart';

const GAMMA = 2.4;
const OFFSET = 0.055;

// moncurve_r with gamma of 2.4 and offset of 0.055 matches the EOTF found in IEC 61966-2-1:1999 (sRGB)
double moncurve_r(double y, double gamma, double offs) {
  double yb =
      pow(offs * gamma / ((gamma - 1.0) * (1.0 + offs)), gamma).toDouble();
  double rs = pow((gamma - 1.0) / offs, gamma - 1.0).toDouble() *
      pow((1.0 + offs) / gamma, gamma);
  return y >= yb ? (1.0 + offs) * pow(y, 1.0 / gamma) - offs : y * rs;
}

Vector3 transferSrgb(Vector3 color) {
  return Vector3(
    moncurve_r(color.x, GAMMA, OFFSET),
    moncurve_r(color.y, GAMMA, OFFSET),
    moncurve_r(color.z, GAMMA, OFFSET),
  );
}
