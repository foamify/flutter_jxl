import 'dart:math';

import 'package:vector_math/vector_math.dart';

const s = 1;
const t = 0.2701;
const m = t;
const c = -0.0729;
const n = 0.4623;

double L(double V) {
  final top = c - (V - m) * s * t;
  final bottom = V - m - s;

  return pow(top / (bottom + 1e-6), 1 / n).toDouble();
}

Vector3 transferBt2100(Vector3 color) {
  return Vector3(
    L(color.x),
    L(color.y),
    L(color.z),
  );
}

double V(double L) {
  final Ln = pow(L, n);

  final top = s * Ln + c;
  final bottom = Ln + s * t;

  return (top / (bottom + 1e-6) + m);
}

Vector3 transferBt2100Inverse(Vector3 color) {
  return Vector3(
    V(color.x),
    V(color.y),
    V(color.z),
  );
}

double normalizeV(double V) {
  const p = 0;
  const m = p;
  const k = 1;

  return (V - p) / k + m;
}

double normalizeL(double L) {
  const a = 1;
  const b = 0;

  return (L - b) / a;
}
