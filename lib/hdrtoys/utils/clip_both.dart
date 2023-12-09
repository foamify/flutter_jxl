import 'package:vector_math/vector_math.dart';

Vector3 clipBothColor(Vector3 color) {
  color.x = color.x.clamp(0.0, 1.0);
  color.y = color.y.clamp(0.0, 1.0);
  color.z = color.z.clamp(0.0, 1.0);

  return color;
}
