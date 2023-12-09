import 'dart:math';

import 'package:vector_math/vector_math.dart';

const beta = 0.018053968510807;
const alpha = 1.0 + 5.5 * beta;

double bt709_f(double V) {
  return V < 4.5 * beta
      ? V / 4.5
      : pow((V + (alpha - 1.0)) / alpha, 1.0 / 0.45).toDouble();
}

Vector3 transferBt709Inverse(Vector3 color) {
  return Vector3(
    bt709_f(color.x),
    bt709_f(color.y),
    bt709_f(color.z),
  );
}
