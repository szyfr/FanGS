package main



//= Imports
import "core:fmt"
import "core:os"

import "raylib"

//= Constants
SETTINGS_FILE_SIZE :: 0x0040


//= Global Variables
settings: ^SettingsStorage;


//= Structures
SettingsStorage :: struct {
	windowWidth:   i32,
	windowHeight:  i32,

	targetFPS:     i32,

	language:      Languages,

	edgeScrolling: bool,

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
	
	// Check for file
	if !os.is_file("data/settings.bin") do create_settings();

	// Load file
	rawData, err := os.read_entire_file_from_filename("data/settings.bin");

	// Grab settings
	settings.windowWidth   = fuse_i32(rawData, 0x00);
	settings.windowHeight  = fuse_i32(rawData, 0x04);
	settings.targetFPS     = fuse_i32(rawData, 0x08);
	settings.language      = Languages(fuse_i32(rawData, 0x0C));
	settings.edgeScrolling = bool(rawData[0x10]);

	// Grab keybindings
	settings.keybindings["up"]    = fuse_keybind(rawData, 0x30);
	settings.keybindings["down"]  = fuse_keybind(rawData, 0x34);
	settings.keybindings["left"]  = fuse_keybind(rawData, 0x38);
	settings.keybindings["right"] = fuse_keybind(rawData, 0x3C);

	// Cleanup
	delete(rawData);
}
free_settings :: proc() {
	free(settings);
}

create_settings :: proc() {
	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(1280, array[0x00:0x04]);
	unfuse_i32( 720, array[0x04:0x08]);
	unfuse_i32(  80, array[0x08:0x0C]);
	unfuse_i32(   0, array[0x0C:0x0F]);
	array[0x10] = u8(settings.edgeScrolling);

	unfuse_keybind(Keybinding{0,265}, array[0x30:0x34]);
	unfuse_keybind(Keybinding{0,264}, array[0x34:0x38]);
	unfuse_keybind(Keybinding{0,263}, array[0x38:0x3C]);
	unfuse_keybind(Keybinding{0,262}, array[0x3C:0x3F]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do add_to_log("[MAJOR]: Failed to save settings.");
}

save_setting :: proc() {
	os.remove("data/settings.bin");

	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(settings.windowWidth,   array[0x00:0x04]);
	unfuse_i32(settings.windowHeight,  array[0x04:0x08]);
	unfuse_i32(settings.targetFPS,     array[0x08:0x0C]);
	unfuse_i32(i32(settings.language), array[0x0C:0x0F]);
	array[0x10] = u8(settings.edgeScrolling);


	unfuse_keybind(settings.keybindings["up"],    array[0x30:0x34]);
	unfuse_keybind(settings.keybindings["down"],  array[0x34:0x38]);
	unfuse_keybind(settings.keybindings["left"],  array[0x38:0x3C]);
	unfuse_keybind(settings.keybindings["right"], array[0x3C:0x3F]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do add_to_log("[MAJOR]: Failed to save settings.");
}