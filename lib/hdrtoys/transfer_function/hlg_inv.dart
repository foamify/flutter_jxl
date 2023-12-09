import 'dart:math';

import 'package:vector_math/vector_math.dart';

const L_sdr = 203.0;

const double L_w = 1000.0;
const double L_b = 0.0;

const double alpha = L_w - L_b;
const double beta = L_b;

double log2(num x) {
  return log(x) / log(2);
}

double gamma = 1.2 * pow(1.111, log2(L_w / 1000.0)).toDouble();

const double a = 0.17883277;
const double b = 1.0 - 4.0 * a;
double c = 0.5 - a * log(4.0 * a);

// HLG EOTF (i.e. HLG inverse OETF followed by the HLG OOTF)
Vector3 HLG_to_Y(Vector3 HLG) {
  // HLG Inverse OETF scene-linear (non-linear signal value to scene linear)
  Vector3 sceneLinear = Vector3(
      HLG.r >= 0.0 && HLG.r <= 0.5
          ? pow(HLG.r, 2.0) / 3.0
          : (exp((HLG.r - c) / a) + b) / 12.0,
      HLG.g >= 0.0 && HLG.g <= 0.5
          ? pow(HLG.g, 2.0) / 3.0
          : (exp((HLG.g - c) / a) + b) / 12.0,
      HLG.b >= 0.0 && HLG.b <= 0.5
          ? pow(HLG.b, 2.0) / 3.0
          : (exp((HLG.b - c) / a) + b) / 12.0);

  // HLG OOTF (scene linear to display linear)
  double Y_s = sceneLinear.dot(
      Vector3(0.2627002120112671, 0.6779980715188708, 0.05930171646986196));
  Vector3 displayLinear =
      sceneLinear * alpha * pow(Y_s, gamma - 1).toDouble() + Vector3.all(beta);

  return displayLinear;
}

Vector3 transferInverseHlg(Vector3 color) {
  color.rgb = HLG_to_Y(color.rgb) / L_sdr;

  return color;
}
