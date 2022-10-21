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
KEY_ZOOMPOS        :: 0x44
KEY_ZOOMNEG        :: 0x48

KEY_DATE_PAUSE     :: 0x4C
KEY_DATE_FAST      :: 0x50
KEY_DATE_SLOW      :: 0x54

KEY_MM_OVERWORLD   :: 0x58
KEY_MM_POLITICAL   :: 0x5C
KEY_MM_TERRAIN     :: 0x60
KEY_MM_CONTROL     :: 0x64
KEY_MM_POPULATION  :: 0x68
KEY_MM_ANCESTRY    :: 0x6C
KEY_MM_CULTURE     :: 0x70
KEY_MM_RELIGION    :: 0x74


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
	settingsdata.keybindings["up"]       = fuse_keybind(rawData, KEY_MOVEUP)
	settingsdata.keybindings["down"]     = fuse_keybind(rawData, KEY_MOVEDOWN)
	settingsdata.keybindings["left"]     = fuse_keybind(rawData, KEY_MOVELEFT)
	settingsdata.keybindings["right"]    = fuse_keybind(rawData, KEY_MOVERIGHT)
	settingsdata.keybindings["grabmap"]  = fuse_keybind(rawData, KEY_GRABMAP)
	settingsdata.keybindings["zoompos"]  = fuse_keybind(rawData, KEY_ZOOMPOS)
	settingsdata.keybindings["zoomneg"]  = fuse_keybind(rawData, KEY_ZOOMNEG)

	settingsdata.keybindings["pause"]    = fuse_keybind(rawData, KEY_DATE_PAUSE)
	settingsdata.keybindings["faster"]   = fuse_keybind(rawData, KEY_DATE_FAST)
	settingsdata.keybindings["slower"]   = fuse_keybind(rawData, KEY_DATE_SLOW)

	settingsdata.keybindings["over"]     = fuse_keybind(rawData, KEY_MM_OVERWORLD)
	settingsdata.keybindings["politic"]  = fuse_keybind(rawData, KEY_MM_POLITICAL)
	settingsdata.keybindings["terrain"]  = fuse_keybind(rawData, KEY_MM_TERRAIN)
	settingsdata.keybindings["control"]  = fuse_keybind(rawData, KEY_MM_CONTROL)
	settingsdata.keybindings["pop"]      = fuse_keybind(rawData, KEY_MM_POPULATION)
	settingsdata.keybindings["ancestry"] = fuse_keybind(rawData, KEY_MM_ANCESTRY)
	settingsdata.keybindings["culture"]  = fuse_keybind(rawData, KEY_MM_CULTURE)
	settingsdata.keybindings["religion"] = fuse_keybind(rawData, KEY_MM_RELIGION)

	//* Logging
	logging.add_to_log("[LOG]: Loaded program settings.")

	//* Cleanup
	delete(rawData)
}

//* Freeing
free_data :: proc() {
	free(gamedata.settingsdata)
}