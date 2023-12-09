import 'dart:math';

import 'package:vector_math/vector_math.dart';

const double L_W = 1.0;
const double L_B = 0.0;

const GAMMA = 2.4;
const OFFSET = 0.055;

// The reference EOTF specified in Rec. ITU-R BT.1886
// L = a(max[(V+b),0])^g
double bt1886_f(double V, double gamma, double Lw, double Lb) {
  double a = pow(pow(Lw, 1.0 / gamma) - pow(Lb, 1.0 / gamma), gamma).toDouble();
  double b =
      pow(Lb, 1.0 / gamma) / (pow(Lw, 1.0 / gamma) - pow(Lb, 1.0 / gamma));
  double L = a * pow(max(V + b, 0.0), gamma);
  return L;
}

Vector3 transferInverse1886(Vector3 color) {
  color.rgb = Vector3(bt1886_f(color.r, GAMMA, L_W, L_B),
      bt1886_f(color.g, GAMMA, L_W, L_B), bt1886_f(color.b, GAMMA, L_W, L_B));

  return color;
}
