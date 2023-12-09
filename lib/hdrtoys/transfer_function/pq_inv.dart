import 'dart:math';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

const m1 = 0.1593017578125;
const m2 = 78.84375;
const c1 = 0.8359375;
const c2 = 18.851525;
const c3 = 18.6875;

const pqC = 1;

double inversePq(double n) {
  final top = max(
    pow(n, 1 / m2) - c1,
    0,
  );
  final bottom = c2 - c3 * pow(n, 1 / m2) + 1e-6;
  final result = pow(top / bottom, 1 / m1).toDouble();
  return result * pqC;
}

Vector3 transferPqInverse(Vector3 color) {
  return Vector3(
    inversePq(color.x),
    inversePq(color.y),
    inversePq(color.z),
  );
}

void applyInversePq(Float32List data) {
  for (var i = 0; i < data.length; i += 3) {
    data[i] = inversePq(data[i]);
    data[i + 1] = inversePq(data[i + 1]);
    data[i + 2] = inversePq(data[i + 2]);
  }
}
