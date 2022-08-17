package settings


//= Imports
import "core:os"

import "../gamedata"


//= Procedures
init :: proc() {
	using gamedata

	settingsdata = new(gamedata.SettingsData)
	
	// Check for file
	if !os.is_file("data/settings.bin") do create_settings()

	// Load file
	rawData, err := os.read_entire_file_from_filename("data/settings.bin")

	// Grab settings
	settingsdata.windowWidth   = fuse_i32(rawData, 0x00)
	settingsdata.windowHeight  = fuse_i32(rawData, 0x04)
	settingsdata.targetFPS     = fuse_i32(rawData, 0x08)
	settingsdata.language      = gamedata.Languages(fuse_i32(rawData, 0x0C))
	settingsdata.edgeScrolling = bool(rawData[0x10])

	switch rawData[0x11] {
		case 0: settingsdata.fontSize = 12; break
		case 1: settingsdata.fontSize = 16; break
		case 2: settingsdata.fontSize = 20; break
	}

	// Grab keybindings
	settingsdata.keybindings["up"]    = fuse_keybind(rawData, 0x30)
	settingsdata.keybindings["down"]  = fuse_keybind(rawData, 0x34)
	settingsdata.keybindings["left"]  = fuse_keybind(rawData, 0x38)
	settingsdata.keybindings["right"] = fuse_keybind(rawData, 0x3C)

	// Cleanup
	delete(rawData)
}
free_data :: proc() {
	free(gamedata.settingsdata)
}