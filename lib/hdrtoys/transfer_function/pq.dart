import 'dart:math';

import 'package:vector_math/vector_math.dart';

const m1 = 0.1593017578125;
const m2 = 78.84375;
const c1 = 0.8359375;
const c2 = 18.851525;
const c3 = 18.6875;

const pqC = 1000 / 203;

double pq(double c) {
  double L = c / pqC;
  double Lm = pow(L, m1).toDouble();
  double N = (c1 + c2 * Lm) / (1.0 + c3 * Lm + 1e-6);
  N = pow(N, m2).toDouble();
  return N;
}

Vector3 pqColor(Vector3 color) {
  return Vector3(
    pq(color.x),
    pq(color.y),
    pq(color.z),
  );
}
