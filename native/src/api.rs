// This is the entry point of your Rust library.
// When adding new code to your project, note that only items used
// here will be transformed to their Dart equivalents.

use std::{
    collections::HashMap,
    io::Cursor,
    sync::{
        mpsc::{self, Receiver, Sender},
        RwLock,
    },
    thread,
};

use flutter_rust_bridge::{frb, ZeroCopyBuffer};
pub use jxl_oxide::{CropInfo, JxlImage};

lazy_static::lazy_static! {
    static ref DECODERS: RwLock<HashMap<String, JxlDecoder>> = {
        RwLock::new(HashMap::new())
    };
}

// A plain enum without any fields. This is similar to Dart- or C-style enums.
// flutter_rust_bridge is capable of generating code for enums with fields
// (@freezed classes in Dart and tagged unions in C).
pub enum Platform {
    Unknown,
    Android,
    Ios,
    Windows,
    Unix,
    MacIntel,
    MacApple,
    Wasm,
}

// A function definition in Rust. Similar to Dart, the return type must always be named
// and is never inferred.
pub fn platform() -> Platform {
    // This is a macro, a special expression that expands into code. In Rust, all macros
    // end with an exclamation mark and can be invoked with all kinds of brackets (parentheses,
    // brackets and curly braces). However, certain conventions exist, for example the
    // vector macro is almost always invoked as vec![..].
    //
    // The cfg!() macro returns a boolean value based on the current compiler configuration.
    // When attached to expressions (#[cfg(..)] form), they show or hide the expression at compile time.
    // Here, however, they evaluate to runtime values, which may or may not be optimized out
    // by the compiler. A variety of configurations are demonstrated here which cover most of
    // the modern oeprating systems. Try running the Flutter application on different machines
    // and see if it matches your expected OS.
    //
    // Furthermore, in Rust, the last expression in a function is the return value and does
    // not have the trailing semicolon. This entire if-else chain forms a single expression.
    if cfg!(windows) {
        Platform::Windows
    } else if cfg!(target_os = "android") {
        Platform::Android
    } else if cfg!(target_os = "ios") {
        Platform::Ios
    } else if cfg!(all(target_os = "macos", target_arch = "aarch64")) {
        Platform::MacApple
    } else if cfg!(target_os = "macos") {
        Platform::MacIntel
    } else if cfg!(target_family = "wasm") {
        Platform::Wasm
    } else if cfg!(unix) {
        Platform::Unix
    } else {
        Platform::Unknown
    }
}

// The convention for Rust identifiers is the snake_case,
// and they are automatically converted to camelCase on the Dart side.
pub fn rust_release_mode() -> bool {
    cfg!(not(debug_assertions))
}

pub fn init_decoder(jxl_bytes: Vec<u8>, key: String) -> JxlInfo {
    {
        let map = DECODERS.read().unwrap();
        if map.contains_key(&key) {
            let decoder = &map[&key];
            return decoder.info;
        }
    }

    let (decoder_request_tx, decoder_request_rx): (
        Sender<DecoderRequest>,
        Receiver<DecoderRequest>,
    ) = mpsc::channel();
    let (decoder_response_tx, decoder_response_rx): (
        Sender<CodecResponse>,
        Receiver<CodecResponse>,
    ) = mpsc::channel();
    let (decoder_info_tx, decoder_info_rx): (Sender<JxlInfo>, Receiver<JxlInfo>) = mpsc::channel();

    thread::spawn(move || {
        let reader = Cursor::new(jxl_bytes);
        let image = JxlImage::from_reader(reader).expect("Failed to decode image");
        let width = image.width();
        let height = image.height();
        let image_count = image.num_loaded_frames();
        let is_animation = image.image_header().metadata.animation.is_some();
        let mut duration = 0.0;
        if is_animation {
            let ticks = image.frame_header(0).unwrap().duration;
            let tps_numerator = image
                .image_header()
                .metadata
                .animation
                .as_ref()
                .unwrap()
                .tps_numerator;
            let tps_denominator = image
                .image_header()
                .metadata
                .animation
                .as_ref()
                .unwrap()
                .tps_denominator;
            duration = ticks as f64 / (tps_numerator as f64 / tps_denominator as f64);
        }

        let mut decoder = Decoder {
            image,
            index: 0,
            count: image_count,
        };

        // ---

        match decoder_info_tx.send(JxlInfo {
            width,
            height,
            duration,
            image_count,
        }) {
            Ok(result) => result,
            Err(e) => panic!("Decoder connection lost. {}", e),
        };

        loop {
            let request = decoder_request_rx.recv().unwrap();
            let response = match request.command {
                DecoderCommand::GetNextFrame => _get_next_frame(&mut decoder, request.crop_info),
                DecoderCommand::Reset => _reset_decoder(),
                DecoderCommand::Dispose => _dispose_decoder(),
            };
            match decoder_response_tx.send(response) {
                Ok(result) => result,
                Err(e) => panic!("Decoder connection lost. {}", e),
            };

            match request.command {
                DecoderCommand::Dispose => break,
                _ => {}
            };
        }
    });

    let jxl_info = match decoder_info_rx.recv() {
        Ok(result) => result,
        Err(e) => panic!("Couldn't read jxl info. Code: {}", e),
    };

    {
        let mut map = DECODERS.write().unwrap();
        map.insert(
            key,
            JxlDecoder {
                request_tx: decoder_request_tx,
                response_rx: decoder_response_rx,
                info: jxl_info,
            },
        );
    }
    return jxl_info;
}

pub fn reset_decoder(key: String) -> bool {
    let map = DECODERS.read().unwrap();
    if !map.contains_key(&key) {
        return false;
    }

    let decoder = &map[&key];
    match decoder.request_tx.send(DecoderRequest {
        crop_info: None,
        command: DecoderCommand::Reset,
    }) {
        Ok(result) => result,
        Err(e) => panic!("Decoder connection lost. {}", e),
    };
    decoder.response_rx.recv().unwrap();
    return true;
}

pub fn dispose_decoder(key: String) -> bool {
    let mut map = DECODERS.write().unwrap();
    if !map.contains_key(&key) {
        return false;
    }

    let decoder = &map[&key];
    match decoder.request_tx.send(DecoderRequest {
        crop_info: None,
        command: DecoderCommand::Dispose,
    }) {
        Ok(result) => result,
        Err(e) => panic!("Decoder connection lost. {}", e),
    };
    decoder.response_rx.recv().unwrap();
    map.remove(&key);
    return true;
}

pub fn get_next_frame(key: String, crop_info: Option<CropInfo>) -> Frame {
    let map = DECODERS.read().unwrap();
    if !map.contains_key(&key) {
        panic!("Decoder not found. {}", key);
    }

    let decoder = &map[&key];

    match decoder.request_tx.send(DecoderRequest {
        command: DecoderCommand::GetNextFrame,
        crop_info,
    }) {
        Ok(result) => result,
        Err(e) => panic!("Decoder connection lost. {}", e),
    };
    let result = decoder.response_rx.recv().unwrap();
    return result.frame;
}

fn _dispose_decoder() -> CodecResponse {
    return CodecResponse {
        frame: Frame {
            data: ZeroCopyBuffer(Vec::new()),
            duration: 0.0,
            width: 0,
            height: 0,
        },
    };
}

fn _reset_decoder() -> CodecResponse {
    return CodecResponse {
        frame: Frame {
            data: ZeroCopyBuffer(Vec::new()),
            duration: 0.0,
            width: 0,
            height: 0,
        },
    };
}

fn _get_next_frame(decoder: &mut Decoder, crop: Option<CropInfo>) -> CodecResponse {
    let image = &decoder.image;

    let next = (decoder.index + 1) % decoder.count;

    decoder.index = next;

    let render = image
        .render_frame_cropped(next, crop)
        .expect("Failed to render frame");

    let render_image = render.image_all_channels();

    let _data = render_image.buf().to_vec();

    return CodecResponse {
        frame: Frame {
            data: ZeroCopyBuffer(_data),
            duration: render.duration() as f64,
            width: render_image.width() as u32,
            height: render_image.height() as u32,
        },
    };
}

pub fn is_jxl(jxl_bytes: Vec<u8>) -> bool {
    let reader = Cursor::new(jxl_bytes);
    let image = JxlImage::from_reader(reader);

    match image {
        Ok(_) => return true,
        Err(_) => return false,
    }
}

pub struct Frame {
    pub data: ZeroCopyBuffer<Vec<f32>>,
    pub duration: f64,
    pub width: u32,
    pub height: u32,
}

#[derive(Copy, Clone)]
pub struct JxlInfo {
    pub width: u32,
    pub height: u32,
    pub image_count: usize,
    pub duration: f64,
}

pub struct Decoder {
    image: JxlImage,
    index: usize,
    count: usize,
}

pub struct JxlDecoder {
    request_tx: Sender<DecoderRequest>,
    response_rx: Receiver<CodecResponse>,
    info: JxlInfo,
}

unsafe impl Send for JxlDecoder {}
unsafe impl Sync for JxlDecoder {}

enum DecoderCommand {
    GetNextFrame,
    Reset,
    Dispose,
}

struct CodecResponse {
    pub frame: Frame,
}

#[frb(mirror(CropInfo))]
pub struct _CropInfo {
    pub width: u32,
    pub height: u32,
    pub left: u32,
    pub top: u32,
}

struct DecoderRequest {
    crop_info: Option<CropInfo>,
    command: DecoderCommand,
}
