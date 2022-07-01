package main



//= Imports
import "core:fmt"
import "core:os"

import "raylib"

//= Constants
SETTINGS_FILE_SIZE :: 16


//= Global Variables
settings: ^SettingsStorage;


//= Structures
SettingsStorage :: struct {
	windowHeight: i32,
	windowWidth:  i32,

	targetFPS:    i32,

	language:     Languages,
}


//= Enumerations
Languages :: enum i32 { english = 0, spanish, german, french, }


//= Procedures

// Initialize
init_settings :: proc() {
	settings = new(SettingsStorage);

	if !os.is_file("data/settings.bin") do create_settings();

	bytes: u32 = 0;
	rawData, err := os.read_entire_file_from_filename("data/settings.bin");

	settings.windowHeight = fuse(rawData,  0);
	settings.windowWidth  = fuse(rawData,  4);
	settings.targetFPS    = fuse(rawData,  8);
	settings.language     = Languages(fuse(rawData, 12));

	delete(rawData);
}
free_settings :: proc() {
	free(settings);
}

create_settings :: proc() {
	array: [SETTINGS_FILE_SIZE]u8;

	unfuse(1280, array[0:4]);
	unfuse( 720, array[4:8]);
	unfuse(  80, array[8:12]);
	unfuse(   0, array[12:16]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do add_to_log("[MAJOR]: Failed to save settings.");
}