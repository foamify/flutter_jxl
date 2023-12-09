import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

const beta = 0.018053968510807;
const alpha = 1.0 + 5.5 * beta;

double bt709_r(double L) {
  return L < beta ? 4.5 * L : alpha * pow(L, 0.45) - (alpha - 1.0);
}

Vector3 transferBt709(Vector3 color) {
  return Vector3(
    bt709_r(color.x),
    bt709_r(color.y),
    bt709_r(color.z),
  );
}
