// This is the entry point of your Rust library.
// When adding new code to your project, note that only items used
// here will be transformed to their Dart equivalents.

use std::io::Cursor;

use flutter_rust_bridge::ZeroCopyBuffer;
use jxl_oxide::JxlImage;

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

pub fn decode_single_frame_image(jxl_bytes: Vec<u8>) -> Frame {
    let reader = Cursor::new(jxl_bytes);

    println!("putting into image");
    let image = JxlImage::from_reader(reader).expect("Failed to read image");

    println!("putting into render");
    let render = image.render_frame(0).expect("Failed to render frame");

    println!("putting into data");
    // let _data = convert_vec_f32_to_vec_u8(render.image().buf().to_vec());
    let _data = render.image_all_channels().buf().to_vec();

    println!("Channels: {}", render.image().channels());

    // TODO: somehow this is performing around 10 - 20 times worse than dart.
    // // if there's only 3 channels, convert to rgba to match flutter
    // if render.image().channels() == 3 {
    //     let mut rgba = vec![0.0; _data.len() * 4 / 3];
    //     let len = _data.len();
    //     for i in (0..len).step_by(3) {
    //         let index = i * 4 / 3;
    //         unsafe {
    //             *rgba.get_unchecked_mut(index) = *_data.get_unchecked(i);
    //             *rgba.get_unchecked_mut(index + 1) = *_data.get_unchecked(i + 1);
    //             *rgba.get_unchecked_mut(index + 2) = *_data.get_unchecked(i + 2);
    //             *rgba.get_unchecked_mut(index + 3) = 1.0;
    //         }
    //     }
    //     println!("putting into frame");
    //     let frame = Frame {
    //         data: ZeroCopyBuffer(rgba),
    //         duration: render.duration() as f64,
    //         width: image.width(),
    //         height: image.height(),
    //     };
    //     println!("returning frame");
    //     return frame;
    // }

    println!("putting into frame");
    let frame = Frame {
        data: ZeroCopyBuffer(_data),
        duration: render.duration() as f64,
        width: image.width(),
        height: image.height(),
    };

    println!("returning frame");
    return frame;
}

pub struct Frame {
    pub data: ZeroCopyBuffer<Vec<f32>>,
    pub duration: f64,
    pub width: u32,
    pub height: u32,
}
