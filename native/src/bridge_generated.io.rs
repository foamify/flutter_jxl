use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_init_decoder(
    port_: i64,
    jxl_bytes: *mut wire_uint_8_list,
    key: *mut wire_uint_8_list,
) {
    wire_init_decoder_impl(port_, jxl_bytes, key)
}

#[no_mangle]
pub extern "C" fn wire_reset_decoder(port_: i64, key: *mut wire_uint_8_list) {
    wire_reset_decoder_impl(port_, key)
}

#[no_mangle]
pub extern "C" fn wire_dispose_decoder(port_: i64, key: *mut wire_uint_8_list) {
    wire_dispose_decoder_impl(port_, key)
}

#[no_mangle]
pub extern "C" fn wire_get_next_frame(
    port_: i64,
    key: *mut wire_uint_8_list,
    crop_info: *mut wire_CropInfo,
) {
    wire_get_next_frame_impl(port_, key, crop_info)
}

#[no_mangle]
pub extern "C" fn wire_is_jxl(port_: i64, jxl_bytes: *mut wire_uint_8_list) {
    wire_is_jxl_impl(port_, jxl_bytes)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_crop_info_0() -> *mut wire_CropInfo {
    support::new_leak_box_ptr(wire_CropInfo::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<CropInfo> for *mut wire_CropInfo {
    fn wire2api(self) -> CropInfo {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<CropInfo>::wire2api(*wrap).into()
    }
}
impl Wire2Api<CropInfo> for wire_CropInfo {
    fn wire2api(self) -> CropInfo {
        CropInfo {
            width: self.width.wire2api(),
            height: self.height.wire2api(),
            left: self.left.wire2api(),
            top: self.top.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_CropInfo {
    width: u32,
    height: u32,
    left: u32,
    top: u32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_CropInfo {
    fn new_with_null_ptr() -> Self {
        Self {
            width: Default::default(),
            height: Default::default(),
            left: Default::default(),
            top: Default::default(),
        }
    }
}

impl Default for wire_CropInfo {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
