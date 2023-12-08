// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.4.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import "bridge_definitions.dart";
import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;

class NativeImpl implements Native {
  final NativePlatform _platform;
  factory NativeImpl(ExternalLibrary dylib) =>
      NativeImpl.raw(NativePlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory NativeImpl.wasm(FutureOr<WasmModule> module) =>
      NativeImpl(module as ExternalLibrary);
  NativeImpl.raw(this._platform);
  Future<JxlInfo> initDecoder(
      {required Uint8List jxlBytes, required String key, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(jxlBytes);
    var arg1 = _platform.api2wire_String(key);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_init_decoder(port_, arg0, arg1),
      parseSuccessData: _wire2api_jxl_info,
      parseErrorData: null,
      constMeta: kInitDecoderConstMeta,
      argValues: [jxlBytes, key],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kInitDecoderConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "init_decoder",
        argNames: ["jxlBytes", "key"],
      );

  Future<bool> resetDecoder({required String key, dynamic hint}) {
    var arg0 = _platform.api2wire_String(key);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_reset_decoder(port_, arg0),
      parseSuccessData: _wire2api_bool,
      parseErrorData: null,
      constMeta: kResetDecoderConstMeta,
      argValues: [key],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kResetDecoderConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "reset_decoder",
        argNames: ["key"],
      );

  Future<bool> disposeDecoder({required String key, dynamic hint}) {
    var arg0 = _platform.api2wire_String(key);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_dispose_decoder(port_, arg0),
      parseSuccessData: _wire2api_bool,
      parseErrorData: null,
      constMeta: kDisposeDecoderConstMeta,
      argValues: [key],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kDisposeDecoderConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "dispose_decoder",
        argNames: ["key"],
      );

  Future<Frame> getNextFrame(
      {required String key, CropInfo? cropInfo, dynamic hint}) {
    var arg0 = _platform.api2wire_String(key);
    var arg1 = _platform.api2wire_opt_box_autoadd_crop_info(cropInfo);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_get_next_frame(port_, arg0, arg1),
      parseSuccessData: _wire2api_frame,
      parseErrorData: null,
      constMeta: kGetNextFrameConstMeta,
      argValues: [key, cropInfo],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetNextFrameConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_next_frame",
        argNames: ["key", "cropInfo"],
      );

  Future<bool> isJxl({required Uint8List jxlBytes, dynamic hint}) {
    var arg0 = _platform.api2wire_uint_8_list(jxlBytes);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_is_jxl(port_, arg0),
      parseSuccessData: _wire2api_bool,
      parseErrorData: null,
      constMeta: kIsJxlConstMeta,
      argValues: [jxlBytes],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kIsJxlConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "is_jxl",
        argNames: ["jxlBytes"],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  Float32List _wire2api_ZeroCopyBuffer_Float32List(dynamic raw) {
    return raw as Float32List;
  }

  Uint8List _wire2api_ZeroCopyBuffer_Uint8List(dynamic raw) {
    return raw as Uint8List;
  }

  bool _wire2api_bool(dynamic raw) {
    return raw as bool;
  }

  double _wire2api_f32(dynamic raw) {
    return raw as double;
  }

  double _wire2api_f64(dynamic raw) {
    return raw as double;
  }

  Float32List _wire2api_float_32_list(dynamic raw) {
    return raw as Float32List;
  }

  Frame _wire2api_frame(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return Frame(
      data: _wire2api_ZeroCopyBuffer_Float32List(arr[0]),
      duration: _wire2api_f64(arr[1]),
      width: _wire2api_u32(arr[2]),
      height: _wire2api_u32(arr[3]),
      icc: _wire2api_opt_ZeroCopyBuffer_Uint8List(arr[4]),
    );
  }

  JxlInfo _wire2api_jxl_info(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 5)
      throw Exception('unexpected arr length: expect 5 but see ${arr.length}');
    return JxlInfo(
      width: _wire2api_u32(arr[0]),
      height: _wire2api_u32(arr[1]),
      imageCount: _wire2api_usize(arr[2]),
      duration: _wire2api_f64(arr[3]),
      isHdr: _wire2api_bool(arr[4]),
    );
  }

  Uint8List? _wire2api_opt_ZeroCopyBuffer_Uint8List(dynamic raw) {
    return raw == null ? null : _wire2api_ZeroCopyBuffer_Uint8List(raw);
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  int _wire2api_usize(dynamic raw) {
    return castInt(raw);
  }
}

// Section: api2wire

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class NativePlatform extends FlutterRustBridgeBase<NativeWire> {
  NativePlatform(ffi.DynamicLibrary dylib) : super(NativeWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_CropInfo> api2wire_box_autoadd_crop_info(CropInfo raw) {
    final ptr = inner.new_box_autoadd_crop_info_0();
    _api_fill_to_wire_crop_info(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_CropInfo> api2wire_opt_box_autoadd_crop_info(CropInfo? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_crop_info(raw);
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_crop_info(
      CropInfo apiObj, ffi.Pointer<wire_CropInfo> wireObj) {
    _api_fill_to_wire_crop_info(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_crop_info(CropInfo apiObj, wire_CropInfo wireObj) {
    wireObj.width = api2wire_u32(apiObj.width);
    wireObj.height = api2wire_u32(apiObj.height);
    wireObj.left = api2wire_u32(apiObj.left);
    wireObj.top = api2wire_u32(apiObj.top);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class NativeWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_init_decoder(
    int port_,
    ffi.Pointer<wire_uint_8_list> jxl_bytes,
    ffi.Pointer<wire_uint_8_list> key,
  ) {
    return _wire_init_decoder(
      port_,
      jxl_bytes,
      key,
    );
  }

  late final _wire_init_decoderPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_init_decoder');
  late final _wire_init_decoder = _wire_init_decoderPtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_reset_decoder(
    int port_,
    ffi.Pointer<wire_uint_8_list> key,
  ) {
    return _wire_reset_decoder(
      port_,
      key,
    );
  }

  late final _wire_reset_decoderPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_reset_decoder');
  late final _wire_reset_decoder = _wire_reset_decoderPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_dispose_decoder(
    int port_,
    ffi.Pointer<wire_uint_8_list> key,
  ) {
    return _wire_dispose_decoder(
      port_,
      key,
    );
  }

  late final _wire_dispose_decoderPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_dispose_decoder');
  late final _wire_dispose_decoder = _wire_dispose_decoderPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_get_next_frame(
    int port_,
    ffi.Pointer<wire_uint_8_list> key,
    ffi.Pointer<wire_CropInfo> crop_info,
  ) {
    return _wire_get_next_frame(
      port_,
      key,
      crop_info,
    );
  }

  late final _wire_get_next_framePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_CropInfo>)>>('wire_get_next_frame');
  late final _wire_get_next_frame = _wire_get_next_framePtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_CropInfo>)>();

  void wire_is_jxl(
    int port_,
    ffi.Pointer<wire_uint_8_list> jxl_bytes,
  ) {
    return _wire_is_jxl(
      port_,
      jxl_bytes,
    );
  }

  late final _wire_is_jxlPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_is_jxl');
  late final _wire_is_jxl = _wire_is_jxlPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  ffi.Pointer<wire_CropInfo> new_box_autoadd_crop_info_0() {
    return _new_box_autoadd_crop_info_0();
  }

  late final _new_box_autoadd_crop_info_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_CropInfo> Function()>>(
          'new_box_autoadd_crop_info_0');
  late final _new_box_autoadd_crop_info_0 = _new_box_autoadd_crop_info_0Ptr
      .asFunction<ffi.Pointer<wire_CropInfo> Function()>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
          ffi
          .NativeFunction<ffi.Pointer<wire_uint_8_list> Function(ffi.Int32)>>(
      'new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_CropInfo extends ffi.Struct {
  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;

  @ffi.Uint32()
  external int left;

  @ffi.Uint32()
  external int top;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
