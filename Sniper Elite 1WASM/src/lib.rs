#![no_std]
#![allow(non_snake_case)]
#![allow(non_upper_case_globals)]
#![allow(static_mut_refs)]

use asr::{future::sleep, settings::{Gui, Map}, Process};
use core::{str, time::Duration};

asr::async_main!(stable);
asr::panic_handler!();

#[derive(Gui)]
struct Settings {
    #[default = true]
    Full_game_run: bool,
    #[default = false]
    Individual_level: bool
}

struct Addr {
    startAddress: u32,
    loadAddress: u32,
    levelAddress: u32,
    warRecordAddress: u32,
    briefingAddress: u32,
    cutsAddress: u32,
    mcAddress: u32,
    fpsAddress: u32
}

impl Addr {
    fn steam() -> Self {
        Self {
            startAddress: 0x35DAD4,
            loadAddress: 0x3A35A9,
            levelAddress: 0x418EED,
            warRecordAddress: 0x418AA8,
            briefingAddress: 0x3B7299,
            cutsAddress: 0x3ADB24,
            mcAddress: 0x3AE2E0,
            fpsAddress: 0x368390
        }
    }

    fn gog() -> Self {
        Self {
            startAddress: 0x2DB89C,
            loadAddress: 0x320D25,
            levelAddress: 0x380CE5,
            warRecordAddress: 0x394D28,
            briefingAddress: 0x333F91,
            cutsAddress: 0x35EC4C,
            mcAddress: 0x32B040,
            fpsAddress: 0x2E60D0
        }
    }
}

async fn main() {
    let mut settings = Settings::register();
    let map = Map::load();
    let mut conflict = false;

    static mut startByte: u8 = 0;

    let mut loadByte: u8 = 0;
    let mut briefingByte: u8 = 0;
    static mut levelStr: &str = "";
    static mut levelArray: [u8; 8] = [0; 8];
    static mut oldLevel: [u8; 8] = [0; 8];

    static mut oldStart: u8 = 0;
    
    static mut fps: f32 = 0.0;
    static mut oldFps: f32 = 0.0;

    static mut mcByte: u16 = 0;

    let mut warRecord: u8 = 0;
    let mut warRecordArray: [u8; 21] = [0; 21];

    let mut cutsByte: u8 = 0;

    let mut baseAddress = asr::Address::new(0);
    let mut addrStruct = Addr::steam();
    loop {
        let process = Process::wait_attach("SniperElite.exe").await;

        process.until_closes(async {
            baseAddress = process.get_module_address("SniperElite.exe").unwrap_or_default();

            if let Ok(moduleSize) = process.get_module_size("SniperElite.exe") {
                if moduleSize == 3805184 {
                    addrStruct = Addr::gog();
                }
            }
            unsafe {
                let mut start = || {
                    cutsByte = process.read::<u8>(baseAddress + addrStruct.cutsAddress).unwrap_or(0);

                    if startByte == 5 && cutsByte == 0 && oldStart == 2 ||
                    levelStr == "level02a" && startByte == 5 && oldStart == 255 {
                        asr::timer::start();
                    }
                };

                let levelSplit = || {
                    if levelArray != oldLevel  {
                        asr::timer::split();
                    }
                };

                let mut isLoading = || {
                    loadByte = process.read::<u8>(baseAddress + addrStruct.loadAddress).unwrap_or(1);
                    briefingByte = process.read::<u8>(baseAddress + addrStruct.briefingAddress).unwrap_or(0);

                    match process.read_into_slice(baseAddress + addrStruct.warRecordAddress, &mut warRecordArray) {
                        Ok(_) => warRecordArray[0],
                        Err(_) => return
                    };
                    let warRecordStr: &str = str::from_utf8(&warRecordArray).unwrap_or("").split('\0').next().unwrap_or("");

                    fps = process.read::<f32>(baseAddress + addrStruct.fpsAddress).unwrap_or(0.0);

                    if fps != oldFps {
                        if oldFps == 60.0 && warRecordStr == "\\splash\\oldmenu1.dds" {
                            warRecord = 1;
                        }
                    }
                    if warRecordStr == "\\splash\\loading\\level"
                    || warRecordStr == "\\splash\\frontsc2.dds" {
                        warRecord = 0;
                    }

                    if loadByte == 0 && (briefingByte != 1 && fps < 1000.0) && warRecord != 1
                    || fps > 1000.0 {
                        asr::timer::pause_game_time();
                    }
                    else {
                        asr::timer::resume_game_time();
                    }
                };

                let lastSplit = || {
                    if levelStr == "level08d" && oldStart == 5 && startByte == 2
                    || levelStr == "level02a" && startByte == 5 && mcByte == 256 {
                        asr::timer::split();
                    }
                };

                let individualLvl = || {
                    if startByte == 5 && mcByte == 256 {
                        asr::timer::split();
                    }
                };
                loop {
                    settings.update();

                    if (settings.Full_game_run && settings.Individual_level) && !conflict {
                        map.store();
                        conflict = true;
                    }
                    else {
                        conflict = false;
                    }

                    startByte = process.read::<u8>(baseAddress + addrStruct.startAddress).unwrap_or(0);

                    process.read_into_slice(baseAddress + addrStruct.levelAddress, &mut levelArray).unwrap_or_default();
                    levelStr = str::from_utf8(&levelArray).unwrap_or("").split('\0').next().unwrap_or("");

                    mcByte = process.read::<u16>(baseAddress + addrStruct.mcAddress).unwrap_or(0);

                    //let start_time = asr::time_util::Instant::now();
                    if settings.Full_game_run {
                        levelSplit();
                        lastSplit();
                    }
                    //let end_time = start_time.elapsed();
                    //asr::print_message(&alloc::format!("Tick time: {:?}", end_time));
                    if settings.Individual_level {
                        individualLvl();
                    }
                    start();
                    isLoading();

                    oldStart = startByte;
                    oldFps = fps;
                    oldLevel = levelArray;
                    sleep(Duration::from_nanos(16666667)).await;
                }
            }
        }).await;
    }
}
