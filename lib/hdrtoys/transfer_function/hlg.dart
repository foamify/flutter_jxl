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

// HLG Inverse EOTF (i.e. HLG inverse OOTF followed by the HLG OETF)
Vector3 Y_to_HLG(Vector3 displayLinear) {
  // HLG Inverse OOTF (display linear to scene linear)
  // This case is to protect against pow(0,-N)=Inf error. The ITU document
  // does not offer a recommendation for this corner case. There may be a
  // better way to handle this, but for now, this works.
  double Y_d = displayLinear.dot(
      Vector3(0.2627002120112671, 0.6779980715188708, 0.05930171646986196));
  Vector3 sceneLinear = Vector3(
      Y_d == 0.0
          ? 0.0
          : pow((Y_d - beta) / alpha, (1.0 - gamma) / gamma) *
              ((displayLinear.r - beta) / alpha),
      Y_d == 0.0
          ? 0.0
          : pow((Y_d - beta) / alpha, (1.0 - gamma) / gamma) *
              ((displayLinear.g - beta) / alpha),
      Y_d == 0.0
          ? 0.0
          : pow((Y_d - beta) / alpha, (1.0 - gamma) / gamma) *
              ((displayLinear.b - beta) / alpha));

  // HLG OETF (scene linear to non-linear signal value)
  Vector3 HLG = Vector3(
      sceneLinear.r <= 1.0 / 12.0
          ? sqrt(3.0 * sceneLinear.r)
          : a * log(12.0 * sceneLinear.r - b) + c,
      sceneLinear.g <= 1.0 / 12.0
          ? sqrt(3.0 * sceneLinear.g)
          : a * log(12.0 * sceneLinear.g - b) + c,
      sceneLinear.b <= 1.0 / 12.0
          ? sqrt(3.0 * sceneLinear.b)
          : a * log(12.0 * sceneLinear.b - b) + c);

  return HLG;
}

Vector3 transferHlg(Vector3 color) {
  color.rgb = Y_to_HLG(color.rgb * L_sdr);

  return color;
}
