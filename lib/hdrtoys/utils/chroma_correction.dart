import 'dart:math';

import 'package:vector_math/vector_math.dart';

const L_hdr = 1000.0;

const L_sdr = 203.0;

const sigma = 0.05;

const alpha = 0.04;

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

double f2(double x, double delta) {
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

  X = f2(X, delta) * XYZ_ref.x;
  Y = f2(Y, delta) * XYZ_ref.y;
  Z = f2(Z, delta) * XYZ_ref.z;

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
    H = ((H % 360.0) + 360.0) % 360.0;
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

double chroma_correction(double L, double Lref, double Lmax, double sigma) {
  if (L > Lref) {
    return max(1.0 - sigma * (L - Lref) / (Lmax - Lref), 0.0);
  }

  return 1.0;
}

Vector3 crosstalk(Vector3 x, double a) {
  double b = 1.0 - 2.0 * a;
  Matrix3 M = Matrix3(b, a, a, a, b, a, a, a, b);
  return M * x;
}

Vector3 crosstalk_inv(Vector3 x, double a) {
  double b = 1.0 - a;
  double c = 1.0 - 3.0 * a;
  Matrix3 M = Matrix3(b, -a, -a, -a, b, -a, -a, -a, b) * (1 / c);
  return M * x;
}

Vector3 chromaCorrectionColor(Vector3 color) {
  double L_ref = RGB_to_Lab(Vector3.all(1.0)).x;
  double L_max = RGB_to_Lab(Vector3.all(L_hdr / L_sdr)).x;

  color.rgb = crosstalk(color.rgb, alpha);
  color.rgb = RGB_to_Lab(color.rgb);
  color.rgb = Lab_to_LCH(color.rgb);
  color.y *= chroma_correction(color.x, L_ref, L_max, sigma);
  color.rgb = LCH_to_Lab(color.rgb);
  color.rgb = Lab_to_RGB(color.rgb);
  color.rgb = crosstalk_inv(color.rgb, alpha);

  return color;
}
