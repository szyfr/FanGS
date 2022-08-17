package settings


//= Imports
import "core:os"

import "../logging"
import "../gamedata"


//= Procedures

//* Create new settings using defaults
create_settings :: proc() {
	using gamedata

	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(1280, array[0x00:0x04]);
	unfuse_i32( 720, array[0x04:0x08]);
	unfuse_i32(  80, array[0x08:0x0C]);
	unfuse_i32(   0, array[0x0C:0x0F]);
	array[0x10] = u8(settingsdata.edgeScrolling);

	switch settingsdata.fontSize {
		case 12: array[0x10] = 0; break;
		case 16: array[0x10] = 1; break;
		case 20: array[0x10] = 2; break;
	}

	unfuse_keybind(Keybinding{0,265}, array[0x30:0x34]);
	unfuse_keybind(Keybinding{0,264}, array[0x34:0x38]);
	unfuse_keybind(Keybinding{0,263}, array[0x38:0x3C]);
	unfuse_keybind(Keybinding{0,262}, array[0x3C:0x3F]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do logging.add_to_log("[MAJOR]: Failed to save settings.");
}

//* Save settings to file using current values
save_setting :: proc() {
	using gamedata

	os.remove("data/settings.bin");

	array: [SETTINGS_FILE_SIZE]u8;

	unfuse_i32(settingsdata.windowWidth,   array[0x00:0x04]);
	unfuse_i32(settingsdata.windowHeight,  array[0x04:0x08]);
	unfuse_i32(settingsdata.targetFPS,     array[0x08:0x0C]);
	unfuse_i32(i32(settingsdata.language), array[0x0C:0x0F]);
	array[0x10] = u8(settingsdata.edgeScrolling);

	switch settingsdata.fontSize {
		case 12: array[0x10] = 0; break;
		case 16: array[0x10] = 1; break;
		case 20: array[0x10] = 2; break;
	}


	unfuse_keybind(settingsdata.keybindings["up"],    array[0x30:0x34]);
	unfuse_keybind(settingsdata.keybindings["down"],  array[0x34:0x38]);
	unfuse_keybind(settingsdata.keybindings["left"],  array[0x38:0x3C]);
	unfuse_keybind(settingsdata.keybindings["right"], array[0x3C:0x3F]);

	res := os.write_entire_file("data/settings.bin", array[:]);
	if !res do logging.add_to_log("[MAJOR]: Failed to save settings.");
}