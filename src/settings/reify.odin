package settings


//= Imports
import "core:os"

import "../gamedata"
import "../logging"


//= Constants
SETTINGS_LOCATION  :: "data/settings.bin"
WINDOW_WIDTH_PTR   :: 0x00
WINDOW_HEIGHT_PTR  :: 0x04
TARGET_FPS_PTR     :: 0x08
LANGUAGE_PTR       :: 0x0C
EDGE_SCROLLING_PTR :: 0x10
FONT_SIZE_PTR      :: 0x11
	FONT_SIZE_SMALL  :: 12
	FONT_SIZE_MED    :: 16
	FONT_SIZE_LARGE  :: 20
KEY_MOVEUP         :: 0x30
KEY_MOVEDOWN       :: 0x34
KEY_MOVELEFT       :: 0x38
KEY_MOVERIGHT      :: 0x3C
KEY_GRABMAP        :: 0x40


//= Procedures

//* Initialization
init :: proc() {
	using gamedata

	//* Init structure
	settingsdata = new(gamedata.SettingsData)
	
	//* Check for file and load
	if !os.is_file(SETTINGS_LOCATION) do create_settings()
	rawData, err := os.read_entire_file_from_filename(SETTINGS_LOCATION)

	//* Grab settings
	settingsdata.windowWidth   = fuse_i32(rawData, WINDOW_WIDTH_PTR)
	settingsdata.windowHeight  = fuse_i32(rawData, WINDOW_HEIGHT_PTR)
	settingsdata.targetFPS     = fuse_i32(rawData, TARGET_FPS_PTR)
	settingsdata.language      = gamedata.Languages(fuse_i32(rawData, LANGUAGE_PTR))
	settingsdata.edgeScrolling = bool(rawData[EDGE_SCROLLING_PTR])
	switch rawData[FONT_SIZE_PTR] {
		case 0: settingsdata.fontSize = FONT_SIZE_SMALL
		case 1: settingsdata.fontSize = FONT_SIZE_MED
		case 2: settingsdata.fontSize = FONT_SIZE_LARGE
	}

	//* Grab keybindings
	settingsdata.keybindings["up"]      = fuse_keybind(rawData, KEY_MOVEUP)
	settingsdata.keybindings["down"]    = fuse_keybind(rawData, KEY_MOVEDOWN)
	settingsdata.keybindings["left"]    = fuse_keybind(rawData, KEY_MOVELEFT)
	settingsdata.keybindings["right"]   = fuse_keybind(rawData, KEY_MOVERIGHT)
	settingsdata.keybindings["grabmap"] = fuse_keybind(rawData, KEY_GRABMAP)

	//* Logging
	logging.add_to_log("[LOG]: Loaded program settings.")

	//* Cleanup
	delete(rawData)
}

//* Freeing
free_data :: proc() {
	free(gamedata.settingsdata)
}