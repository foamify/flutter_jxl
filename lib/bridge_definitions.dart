// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.4.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

abstract class Native {
  Future<JxlInfo> initDecoder(
      {required Uint8List jxlBytes, required String key, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kInitDecoderConstMeta;

  Future<bool> resetDecoder({required String key, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kResetDecoderConstMeta;

  Future<bool> disposeDecoder({required String key, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kDisposeDecoderConstMeta;

  Future<Frame> getNextFrame(
      {required String key, CropInfo? cropInfo, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetNextFrameConstMeta;

  Future<bool> isJxl({required Uint8List jxlBytes, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kIsJxlConstMeta;
}

class CropInfo {
  final int width;
  final int height;
  final int left;
  final int top;

  const CropInfo({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
  });
}

class Frame {
  final Float32List data;
  final double duration;
  final int width;
  final int height;
  final Uint8List? icc;

  const Frame({
    required this.data,
    required this.duration,
    required this.width,
    required this.height,
    this.icc,
  });
}

class JxlInfo {
  final int width;
  final int height;
  final int imageCount;
  final double duration;
  final bool isHdr;

  const JxlInfo({
    required this.width,
    required this.height,
    required this.imageCount,
    required this.duration,
    required this.isHdr,
  });
}
