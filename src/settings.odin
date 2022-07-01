package main



//= Imports
import "core:fmt"
import "core:os"

import "raylib"

//= Constants
SETTINGS_FILE_SIZE :: 32


//= Global Variables
settings: ^SettingsStorage;


//= Structures
SettingsStorage :: struct {
	windowWidth: i32,
	windowHeight:  i32,

	targetFPS:    i32,

	language:     Languages,

	keybindings: map[string]Keybinding,
}
Keybinding :: struct {
	origin: u8,
	key:    u32,
}


//= Enumerations
Languages   :: enum i32 { english = 0, spanish, german, french, }


//= Procedures

// Initialize
init_settings :: proc() {
	settings = new(SettingsStorage);

	if !os.is_file("data/settings.bin") do create_settings();

	bytes: u32 = 0;
	rawData, err := os.read_entire_file_from_filename("data/settings.bin");

	settings.windowWidth  = fuse_i32(rawData,  0);
	settings.windowHeight = fuse_i32(rawData,  4);
	settings.targetFPS    = fuse_i32(rawData,  8);
	settings.language     = Languages(fuse_i32(rawData, 12));

	settings.keybindings["up"]    = fuse_keybind(rawData, 16);
	settings.keybindings["down"]  = fuse_keybind(rawData, 20);
	settings.keybindings["left"]  = fuse_keybind(rawData, 24);
	settings.keybindings["right"] = fuse_keybind(rawData, 28);

	delete(rawData);
}
free_settings :: proc() {
	free(settings);
}

create_settings :: proc() {
	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(1280, array[0:4]);
	unfuse_i32( 720, array[4:8]);
	unfuse_i32(  80, array[8:12]);
	unfuse_i32(   0, array[12:16]);

	unfuse_keybind(Keybinding{0,265}, array[16:20]);
	unfuse_keybind(Keybinding{0,264}, array[20:24]);
	unfuse_keybind(Keybinding{0,263}, array[24:28]);
	unfuse_keybind(Keybinding{0,262}, array[28:32]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do add_to_log("[MAJOR]: Failed to save settings.");
}

save_setting :: proc() {
	os.remove("data/settings.bin");

	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(settings.windowWidth,   array[0:4]);
	unfuse_i32(settings.windowHeight,  array[4:8]);
	unfuse_i32(settings.targetFPS,     array[8:12]);
	unfuse_i32(i32(settings.language), array[12:16]);

	unfuse_keybind(settings.keybindings["up"],    array[16:20]);
	unfuse_keybind(settings.keybindings["down"],  array[20:24]);
	unfuse_keybind(settings.keybindings["left"],  array[24:28]);
	unfuse_keybind(settings.keybindings["right"], array[28:32]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do add_to_log("[MAJOR]: Failed to save settings.");
}