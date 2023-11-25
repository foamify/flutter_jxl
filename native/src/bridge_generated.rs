#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.4.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::rust2dart::IntoIntoDart;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

// Section: wire functions

fn wire_platform_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Platform, _>(
        WrapInfo {
            debug_name: "platform",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Result::<_, ()>::Ok(platform()),
    )
}
fn wire_rust_release_mode_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, bool, _>(
        WrapInfo {
            debug_name: "rust_release_mode",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| Result::<_, ()>::Ok(rust_release_mode()),
    )
}
fn wire_init_decoder_impl(
    port_: MessagePort,
    jxl_bytes: impl Wire2Api<Vec<u8>> + UnwindSafe,
    key: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, JxlInfo, _>(
        WrapInfo {
            debug_name: "init_decoder",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_jxl_bytes = jxl_bytes.wire2api();
            let api_key = key.wire2api();
            move |task_callback| Result::<_, ()>::Ok(init_decoder(api_jxl_bytes, api_key))
        },
    )
}
fn wire_reset_decoder_impl(port_: MessagePort, key: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, bool, _>(
        WrapInfo {
            debug_name: "reset_decoder",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key = key.wire2api();
            move |task_callback| Result::<_, ()>::Ok(reset_decoder(api_key))
        },
    )
}
fn wire_dispose_decoder_impl(port_: MessagePort, key: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, bool, _>(
        WrapInfo {
            debug_name: "dispose_decoder",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key = key.wire2api();
            move |task_callback| Result::<_, ()>::Ok(dispose_decoder(api_key))
        },
    )
}
fn wire_get_next_frame_impl(port_: MessagePort, key: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, Frame, _>(
        WrapInfo {
            debug_name: "get_next_frame",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key = key.wire2api();
            move |task_callback| Result::<_, ()>::Ok(get_next_frame(api_key))
        },
    )
}
fn wire_is_jxl_impl(port_: MessagePort, jxl_bytes: impl Wire2Api<Vec<u8>> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap::<_, _, _, bool, _>(
        WrapInfo {
            debug_name: "is_jxl",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_jxl_bytes = jxl_bytes.wire2api();
            move |task_callback| Result::<_, ()>::Ok(is_jxl(api_jxl_bytes))
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for Frame {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.data.into_into_dart().into_dart(),
            self.duration.into_into_dart().into_dart(),
            self.width.into_into_dart().into_dart(),
            self.height.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Frame {}
impl rust2dart::IntoIntoDart<Frame> for Frame {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for JxlInfo {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.width.into_into_dart().into_dart(),
            self.height.into_into_dart().into_dart(),
            self.image_count.into_into_dart().into_dart(),
            self.duration.into_into_dart().into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for JxlInfo {}
impl rust2dart::IntoIntoDart<JxlInfo> for JxlInfo {
    fn into_into_dart(self) -> Self {
        self
    }
}

impl support::IntoDart for Platform {
    fn into_dart(self) -> support::DartAbi {
        match self {
            Self::Unknown => 0,
            Self::Android => 1,
            Self::Ios => 2,
            Self::Windows => 3,
            Self::Unix => 4,
            Self::MacIntel => 5,
            Self::MacApple => 6,
            Self::Wasm => 7,
        }
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Platform {}
impl rust2dart::IntoIntoDart<Platform> for Platform {
    fn into_into_dart(self) -> Self {
        self
    }
}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;
