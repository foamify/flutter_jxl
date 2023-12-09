import 'dart:math';

import 'package:vector_math/vector_math.dart';

// https://github.com/jedypod/gamut-compress
// https://github.com/ampas/aces-dev/blob/dev/transforms/ctl/lmt/LMT.Academy.ReferenceGamutCompress.ctl
// Pick compressed color's chroma replace the orginal color's chroma in CIE-Lab.

//!PARAM cyan_limit
//!TYPE float
//!MINIMUM 1.000001
//!MAXIMUM 2

const cyan_limit = 1.5187050250638159;

//!PARAM magenta_limit
//!TYPE float
//!MINIMUM 1.000001
//!MAXIMUM 2
const magenta_limit = 1.0750082769546088;

//!PARAM yellow_limit
//!TYPE float
//!MINIMUM 1.000001
//!MAXIMUM 2
const yellow_limit = 1.0887800403483898;

//!PARAM cyan_threshold
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 2
const cyan_threshold = 1.050508660266247;

//!PARAM magenta_threshold
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 2
const magenta_threshold = 0.940509816042432;

//!PARAM yellow_threshold
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 2
const yellow_threshold = 0.9771607996420639;

//!PARAM L_sdr
//!TYPE float
//!MINIMUM 0
//!MAXIMUM 1000
const L_sdr = 203.0;

//!HOOK OUTPUT
//!BIND HOOKED
//!DESC gamut mapping (jedypod)

// #define func    parabolic

// Parabolic compression function: https://www.desmos.com/calculator/nvhp63hmtj
double parabolic(double dist, double lim, double thr) {
  if (dist > thr) {
    // Calculate scale so compression function passes through distance limit: (x=dl, y=1)
    double scale = (1.0 - thr) / sqrt(lim - 1.0);
    double sacle_ = scale * scale / 4.0;
    dist = scale * (sqrt(dist - thr + sacle_) - sqrt(sacle_)) + thr;
  }

  return dist;
}

double power(double dist, double lim, double thr) {
  double pwr = 1.2;

  if (dist > thr) {
    // Calculate scale factor for y = 1 intersect
    double scl = (lim - thr) /
        pow(pow((1.0 - thr) / (lim - thr), -pwr) - 1.0, 1.0 / pwr);

    // Normalize distance outside threshold by scale factor
    double nd = (dist - thr) / scl;
    double p = pow(nd, pwr).toDouble();

    // Compress
    dist = thr + scl * nd / (pow(1.0 + p, 1.0 / pwr));
  }

  return dist;
}

Vector3 gamut_compress(Vector3 rgb) {
  // Distance limit: How far beyond the gamut boundary to compress
  Vector3 dl = Vector3(cyan_limit, magenta_limit, yellow_limit);

  // Amount of outer gamut to affect
  Vector3 th = Vector3(cyan_threshold, magenta_threshold, yellow_threshold);

  // Achromatic axis
  double ac = max(max(rgb.r, rgb.g), rgb.b);

  // Inverse RGB Ratios: distance from achromatic axis
  Vector3 d = ac == 0.0 ? Vector3.zero() : (Vector3.all(ac) - rgb) / ac.abs();

  // Compressed distance
  Vector3 cd = Vector3(parabolic(d.x, dl.x, th.x), parabolic(d.y, dl.y, th.y),
      parabolic(d.z, dl.z, th.z));

  // Inverse RGB Ratios to RGB
  Vector3 crgb = Vector3.all(ac) - cd * ac.abs();

  return crgb;
}

double cbrt(double x) => (x.sign * pow(x.abs(), 1.0 / 3.0));

Vector3 RGB_to_XYZ(Vector3 RGB) {
  Matrix3 M = Matrix3(
      0.6369580483012914,
      0.14461690358620832,
      0.1688809751641721,
      0.2627002120112671,
      0.6779980715188708,
      0.05930171646986196,
      0.000000000000000,
      0.028072693049087428,
      1.060985057710791);
  return M * RGB;
}

Vector3 XYZ_to_RGB(Vector3 XYZ) {
  Matrix3 M = Matrix3(
      1.716651187971268,
      -0.355670783776392,
      -0.253366281373660,
      -0.666684351832489,
      1.616481236634939,
      0.0157685458139111,
      0.017639857445311,
      -0.042770613257809,
      0.942103121235474);
  return M * XYZ;
}

Vector3 XYZD65_to_XYZD50(Vector3 XYZ) {
  Matrix3 M = Matrix3(
      1.0479298208405488,
      0.022946793341019088,
      -0.05019222954313557,
      0.029627815688159344,
      0.990434484573249,
      -0.01707382502938514,
      -0.009243058152591178,
      0.015055144896577895,
      0.7518742899580008);
  return M * XYZ;
}

Vector3 XYZD50_to_XYZD65(Vector3 XYZ) {
  Matrix3 M = Matrix3(
      0.9554734527042182,
      -0.023098536874261423,
      0.0632593086610217,
      -0.028369706963208136,
      1.0099954580058226,
      0.021041398966943008,
      0.012314001688319899,
      -0.020507696433477912,
      1.3303659366080753);
  return M * XYZ;
}

double delta = 6.0 / 29.0;
double deltac = delta * 2.0 / 3.0;

double f1(double x, double delta) {
  return x > pow(delta, 3.0) ? cbrt(x) : deltac + x / (3.0 * pow(delta, 2.0));
}

double f2_2(double x, double delta) {
  return x > delta
      ? pow(x, 3.0).toDouble()
      : (x - deltac) * (3.0 * pow(delta, 2.0));
}

Vector3 XYZ_ref = RGB_to_XYZ(Vector3.all(L_sdr));

Vector3 XYZ_to_Lab(Vector3 XYZ) {
  double X = XYZ.x;
  double Y = XYZ.y;
  double Z = XYZ.z;

  X = f1(X / XYZ_ref.x, delta);
  Y = f1(Y / XYZ_ref.y, delta);
  Z = f1(Z / XYZ_ref.z, delta);

  double L = 116.0 * Y - 16.0;
  double a = 500.0 * (X - Y);
  double b = 200.0 * (Y - Z);

  return Vector3(L, a, b);
}

Vector3 Lab_to_XYZ(Vector3 Lab) {
  double L = Lab.x;
  double a = Lab.y;
  double b = Lab.z;

  double Y = (L + 16.0) / 116.0;
  double X = Y + a / 500.0;
  double Z = Y - b / 200.0;

  X = f2_2(X, delta) * XYZ_ref.x;
  Y = f2_2(Y, delta) * XYZ_ref.y;
  Z = f2_2(Z, delta) * XYZ_ref.z;

  return Vector3(X, Y, Z);
}

Vector3 RGB_to_Lab(Vector3 color) {
  color *= L_sdr;
  color = RGB_to_XYZ(color);
  color = XYZD65_to_XYZD50(color);
  color = XYZ_to_Lab(color);
  return color;
}

Vector3 Lab_to_RGB(Vector3 color) {
  color = Lab_to_XYZ(color);
  color = XYZD50_to_XYZD65(color);
  color = XYZ_to_RGB(color);
  color /= L_sdr;
  return color;
}

const double pi = 3.141592653589793;
const double epsilon = 1e-6;

Vector3 Lab_to_LCH(Vector3 Lab) {
  double a = Lab.y;
  double b = Lab.z;

  double C = Vector2(a, b).length;
  double H = 0.0;

  if (!(a.abs() < epsilon && b.abs() < epsilon)) {
    H = atan2(b, a);
    H = H * 180.0 / pi;
    H = (((H % 360.0) + 360.0) % 360.0);
  }

  return Vector3(Lab.x, C, H);
}

Vector3 LCH_to_Lab(Vector3 LCH) {
  double C = max(LCH.y, 0.0);
  double H = LCH.z * pi / 180.0;

  double a = C * cos(H);
  double b = C * sin(H);

  return Vector3(LCH.x, a, b);
}

Matrix3 M = Matrix3(1.660491, -0.587641, -0.072850, -0.124550, 1.132900,
    -0.008349, -0.018151, -0.100579, 1.118730);

Matrix3 M_inv = Matrix3(0.627404, 0.329283, 0.043313, 0.069097, 0.919540,
    0.011362, 0.016391, 0.088013, 0.895595);

Vector3 gamutMapJedypodColor(Vector3 color) {
  Vector3 color_crgb = color.rgb;

  color_crgb = M_inv * gamut_compress(M * color_crgb);
  color_crgb = RGB_to_Lab(color_crgb);
  color_crgb = Lab_to_LCH(color_crgb);

  color.rgb = RGB_to_Lab(color.rgb);
  color.rgb = Lab_to_LCH(color.rgb);
  color.y = color_crgb.y;
  color.rgb = LCH_to_Lab(color.rgb);
  color.rgb = Lab_to_RGB(color.rgb);
  color.rgb = M * color.rgb;

  return color;
}
