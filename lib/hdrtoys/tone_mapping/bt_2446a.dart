import 'dart:math';

import 'package:vector_math/vector_math.dart';

// ITU-R BT.2446 Conversion Method A
// https://www.itu.int/pub/R-REP-BT.2446

const L_hdr = 1000.0;

const L_sdr = 203.0;

//!HOOK OUTPUT
//!BIND HOOKED
//!DESC tone mapping (bt.2446a)

const double a = 0.2627002120112671;
const double b = 0.6779980715188708;
const double c = 0.05930171646986196;
const double d = 2.0 * (1.0 - c);
const double e = 2.0 * (1.0 - a);

Vector3 RGB_to_YCbCr(Vector3 RGB) {
  double R = RGB.r;
  double G = RGB.g;
  double B = RGB.b;

  double Y = RGB.dot(Vector3(a, b, c));
  double Cb = (B - Y) / d;
  double Cr = (R - Y) / e;

  return Vector3(Y, Cb, Cr);
}

Vector3 YCbCr_to_RGB(Vector3 YCbCr) {
  double Y = YCbCr.x;
  double Cb = YCbCr.y;
  double Cr = YCbCr.z;

  double R = Y + e * Cr;
  double G = Y - (a * e / b) * Cr - (c * d / b) * Cb;
  double B = Y + d * Cb;

  return Vector3(R, G, B);
}

double f(double Yin) {
  var Y = pow(Yin, 1.0 / 2.4).toDouble();

  double pHDR = 1.0 + 32.0 * pow(L_hdr / 10000.0, 1.0 / 2.4);
  double pSDR = 1.0 + 32.0 * pow(L_sdr / 10000.0, 1.0 / 2.4);

  double Yp = log(1.0 + (pHDR - 1.0) * Y) / log(pHDR);

  double Yc;
  if (Yp <= 0.7399)
    Yc = Yp * 1.0770;
  else if (Yp < 0.9909)
    Yc = Yp * (-1.1510 * Yp + 2.7811) - 0.6302;
  else
    Yc = Yp * 0.5000 + 0.5000;

  double Ysdr = (pow(pSDR, Yc) - 1.0) / (pSDR - 1.0);

  Y = pow(Ysdr, 2.4).toDouble();

  return Y;
}

Vector3 tone_mapping(Vector3 YCbCr) {
  double W = L_hdr / L_sdr;
  YCbCr /= W;

  double Y = YCbCr.r;
  double Cb = YCbCr.g;
  double Cr = YCbCr.b;

  double Ysdr = f(Y);

  double Yr = Ysdr / (1.1 * Y + 1e-6);
  Cb *= Yr;
  Cr *= Yr;
  Y = Ysdr - max(0.1 * Cr, 0.0);

  return Vector3(Y, Cb, Cr);
}

Vector3 toneMap2446a(Vector3 color) {
  color.rgb = RGB_to_YCbCr(color.rgb);
  color.rgb = tone_mapping(color.rgb);
  color.rgb = YCbCr_to_RGB(color.rgb);

  return color;
}
