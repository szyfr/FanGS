package settings


//= Imports
import "core:os"


//= Procedures
init :: proc() -> ^SettingsData {
	settings := new(SettingsData)
	
	// Check for file
	if !os.is_file("data/settings.bin") do create_settings(settings)

	// Load file
	rawData, err := os.read_entire_file_from_filename("data/settings.bin")

	// Grab settings
	settings.windowWidth   = fuse_i32(rawData, 0x00)
	settings.windowHeight  = fuse_i32(rawData, 0x04)
	settings.targetFPS     = fuse_i32(rawData, 0x08)
	settings.language      = Languages(fuse_i32(rawData, 0x0C))
	settings.edgeScrolling = bool(rawData[0x10])

	switch rawData[0x11] {
		case 0: settings.fontSize = 12; break
		case 1: settings.fontSize = 16; break
		case 2: settings.fontSize = 20; break
	}

	// Grab keybindings
	settings.keybindings["up"]    = fuse_keybind(rawData, 0x30)
	settings.keybindings["down"]  = fuse_keybind(rawData, 0x34)
	settings.keybindings["left"]  = fuse_keybind(rawData, 0x38)
	settings.keybindings["right"] = fuse_keybind(rawData, 0x3C)

	// Cleanup
	delete(rawData)

	return settings
}
free :: proc(settings : ^SettingsData) {
	free(settings)
}