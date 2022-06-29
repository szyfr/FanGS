package main



//= Imports
import "core:fmt"

import "raylib"

//= Constants

//= Global Variables
settings: ^SettingsStorage;


//= Structures
SettingsStorage :: struct {
	windowHeight: i32,
	windowWidth:  i32,

	targetFPS:    i32,
}


//= Enumerations

//= Procedures

// Initialize
init_settings :: proc() -> bool {
	settings = new(SettingsStorage);

	if !raylib.file_exists("data/settings.bin") {
		settings.windowHeight = 1280;
		settings.windowWidth  =  720;
	}

	bytes: u32 = 0;
	rawData: [^]u8 = (raylib.load_file_data("data/settings.bin", &bytes));

	settings.windowHeight = fuse(rawData, 0);
	settings.windowWidth  = fuse(rawData, 4);
	settings.targetFPS    = fuse(rawData, 8);

	raylib.unload_file_data(rawData);

	return true;
}
free_settings :: proc() {
	free(settings);
}