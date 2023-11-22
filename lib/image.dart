import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MemoryJxlImage extends ImageProvider<MemoryJxlImage> {
  @override
  Future<MemoryJxlImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MemoryJxlImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      MemoryJxlImage key, ImageDecoderCallback decode) {
    return super.loadImage(key, decode);
  }
}

class JxlImageStreamCompleter extends ImageStreamCompleter {
  JxlImageStreamCompleter() : super();
}
