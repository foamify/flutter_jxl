// This is the entry point of your Rust library.
// When adding new code to your project, note that only items used
// here will be transformed to their Dart equivalents.

use std::{collections::HashMap, io::Cursor, sync::RwLock};

use flutter_rust_bridge::ZeroCopyBuffer;
use jxl_oxide::JxlImage;

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

            let image = &decoder.image;
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

            let duration = ticks as f64 / (tps_numerator as f64 / tps_denominator as f64);

            return JxlInfo {
                width: decoder.image.width(),
                height: decoder.image.height(),
                image_count: decoder.image.num_loaded_frames(),
                duration,
            };
        }
    }

    let reader = Cursor::new(jxl_bytes);
    let image = JxlImage::from_reader(reader).expect("Failed to read image");

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

    let decoder = JxlDecoder {
        image,
        index: 0,
        count: image_count,
    };

    {
        let mut map = DECODERS.write().unwrap();
        map.insert(key, decoder);
    }

    return JxlInfo {
        width,
        height,
        image_count,
        duration,
    };
}

pub fn reset_decoder(key: String) -> bool {
    let map = DECODERS.read().unwrap();
    if !map.contains_key(&key) {
        return false;
    }

    // let decoder = &map[&key];
    // match decoder.request_tx.send(DecoderCommand::Reset) {
    //     Ok(result) => result,
    //     Err(e) => panic!("Decoder connection lost. {}", e),
    // };
    // decoder.response_rx.recv().unwrap();
    return true;
}

pub fn dispose_decoder(key: String) -> bool {
    let mut map = DECODERS.write().unwrap();
    if !map.contains_key(&key) {
        return false;
    }

    // let decoder = &map[&key];
    // match decoder.request_tx.send(DecoderCommand::Dispose) {
    //     Ok(result) => result,
    //     Err(e) => panic!("Decoder connection lost. {}", e),
    // };
    // decoder.response_rx.recv().unwrap();
    map.remove(&key);
    return true;
}

pub fn is_jxl(jxl_bytes: Vec<u8>) -> bool {
    let reader = Cursor::new(jxl_bytes);
    let image = JxlImage::from_reader(reader);

    match image {
        Ok(_) => return true,
        Err(_) => return false,
    }
}

pub fn get_frame_count(key: String) -> usize {
    let map = DECODERS.read().unwrap();
    // Now you can use `map` instead of calling `map.read().unwrap()`

    // Example usage:
    let decoder = map.get(&key).unwrap();

    return decoder.image.num_loaded_frames();
}

pub fn get_channel_count(key: String) -> usize {
    let map = DECODERS.read().unwrap();
    // Now you can use `map` instead of calling `map.read().unwrap()`

    // Example usage:
    let decoder = map.get(&key).unwrap();

    return decoder.image.pixel_format().channels();
}

pub fn get_next_frame(key: String) -> Frame {
    let frame: Frame;

    let next: usize;

    {
        let map = DECODERS.read().unwrap();

        let decoder = map.get(&key).unwrap();

        next = (decoder.index + 1) % decoder.count;

        let image = &decoder.image;

        let render = image.render_frame(next).expect("Failed to render frame");

        let _data = render.image_all_channels().buf().to_vec();

        frame = Frame {
            data: ZeroCopyBuffer(_data),
            duration: render.duration() as f64,
            width: image.width(),
            height: image.height(),
        };
    }

    {
        let mut map = DECODERS.write().unwrap();
        map.get_mut(&key).unwrap().index = next;
    }

    return frame;
}

pub struct Frame {
    pub data: ZeroCopyBuffer<Vec<f32>>,
    pub duration: f64,
    pub width: u32,
    pub height: u32,
}

pub struct JxlDecoder {
    pub image: JxlImage,
    pub index: usize,
    pub count: usize,
}

#[derive(Copy, Clone)]
pub struct JxlInfo {
    pub width: u32,
    pub height: u32,
    pub image_count: usize,
    pub duration: f64,
}
