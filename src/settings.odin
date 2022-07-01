package main



//= Imports
import "core:fmt"

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

	if !raylib.file_exists("data/settings.bin") do create_settings();

	bytes: u32 = 0;
	rawData: [^]u8 = (raylib.load_file_data("data/settings.bin", &bytes));

	settings.windowHeight = fuse(rawData,  0);
	settings.windowWidth  = fuse(rawData,  4);
	settings.targetFPS    = fuse(rawData,  8);
	settings.language     = Languages(fuse(rawData, 12));

	raylib.unload_file_data(rawData);
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

	raylib.save_file_data("data/settings.bin", rawptr(&array), SETTINGS_FILE_SIZE);
}