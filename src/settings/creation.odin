package settings


//= Imports
import "core:os"

import "../logging"
import "../gamedata"


//= Constants
SETTINGS_FILE_SIZE   :: 0x0078
SETTING_SAVE_FAILURE :: "[MAJOR]: Failed to save settings."
SETTING_SAVE_SUCCESS :: "[LOG]: Saved settings."

DEFAULT_WIDTH  ::  1280
DEFAULT_HEIGHT ::   720
DEFAULT_FPS    ::    80
DEFAULT_LANG   ::     0
DEFAULT_EDGE   ::     0
DEFAULT_FONT   ::    16


//= Procedures

//* Create new settings using defaults
create_settings :: proc() {
	using gamedata

	//* Logging
	logging.add_to_log("[LOG]: Failed to find settings. Creating new file.")

	//* Create array
	array: [SETTINGS_FILE_SIZE]u8

	//* Set default values
	unfuse_i32(DEFAULT_WIDTH,  array[WINDOW_WIDTH_PTR  : WINDOW_HEIGHT_PTR])
	unfuse_i32(DEFAULT_HEIGHT, array[WINDOW_HEIGHT_PTR : TARGET_FPS_PTR])
	unfuse_i32(DEFAULT_FPS,    array[TARGET_FPS_PTR    : LANGUAGE_PTR])
	unfuse_i32(DEFAULT_LANG,   array[LANGUAGE_PTR      : EDGE_SCROLLING_PTR])
	array[EDGE_SCROLLING_PTR] = DEFAULT_EDGE
	array[FONT_SIZE_PTR]      = DEFAULT_FONT
	unfuse_keybind(Keybinding{0,265}, array[KEY_MOVEUP        : KEY_MOVEDOWN])
	unfuse_keybind(Keybinding{0,264}, array[KEY_MOVEDOWN      : KEY_MOVELEFT])
	unfuse_keybind(Keybinding{0,263}, array[KEY_MOVELEFT      : KEY_MOVERIGHT])
	unfuse_keybind(Keybinding{0,262}, array[KEY_MOVERIGHT     : KEY_GRABMAP])
	unfuse_keybind(Keybinding{1,  2}, array[KEY_GRABMAP       : KEY_ZOOMPOS])
	unfuse_keybind(Keybinding{2,  0}, array[KEY_ZOOMPOS       : KEY_ZOOMNEG])
	unfuse_keybind(Keybinding{2,  1}, array[KEY_ZOOMNEG       : KEY_DATE_PAUSE])
	unfuse_keybind(Keybinding{0, 32}, array[KEY_DATE_PAUSE    : KEY_DATE_FAST])
	unfuse_keybind(Keybinding{0, 61}, array[KEY_DATE_FAST     : KEY_DATE_SLOW])
	unfuse_keybind(Keybinding{0, 45}, array[KEY_DATE_SLOW     : KEY_MM_OVERWORLD])
	unfuse_keybind(Keybinding{0, 49}, array[KEY_MM_OVERWORLD  : KEY_MM_POLITICAL])
	unfuse_keybind(Keybinding{0, 50}, array[KEY_MM_POLITICAL  : KEY_MM_TERRAIN])
	unfuse_keybind(Keybinding{0, 51}, array[KEY_MM_TERRAIN    : KEY_MM_CONTROL])
	unfuse_keybind(Keybinding{0, 52}, array[KEY_MM_CONTROL    : KEY_MM_POPULATION])
	unfuse_keybind(Keybinding{0, 53}, array[KEY_MM_POPULATION : KEY_MM_ANCESTRY])
	unfuse_keybind(Keybinding{0, 54}, array[KEY_MM_ANCESTRY   : KEY_MM_CULTURE])
	unfuse_keybind(Keybinding{0, 55}, array[KEY_MM_CULTURE    : KEY_MM_RELIGION])
	unfuse_keybind(Keybinding{0, 56}, array[KEY_MM_RELIGION   : 0x78])

	//* Save settings
	res := os.write_entire_file(SETTINGS_LOCATION, array[:])
	if !res do logging.add_to_log(SETTING_SAVE_FAILURE)
	else    do logging.add_to_log(SETTING_SAVE_SUCCESS)
}

//* Save settings to file using current values
save_setting :: proc() {
	using gamedata

	//* Check for existing file
	if os.is_file(SETTINGS_LOCATION) do os.remove(SETTINGS_LOCATION)

	//* Create array
	array: [SETTINGS_FILE_SIZE]u8

	unfuse_i32(settingsdata.windowWidth,   array[WINDOW_WIDTH_PTR  : WINDOW_HEIGHT_PTR])
	unfuse_i32(settingsdata.windowHeight,  array[WINDOW_HEIGHT_PTR : TARGET_FPS_PTR])
	unfuse_i32(settingsdata.targetFPS,     array[TARGET_FPS_PTR    : LANGUAGE_PTR])
	unfuse_i32(i32(settingsdata.language), array[LANGUAGE_PTR      : EDGE_SCROLLING_PTR])
	array[EDGE_SCROLLING_PTR] = u8(settingsdata.edgeScrolling)
	switch settingsdata.fontSize {
		case 12: array[FONT_SIZE_PTR] = 0
		case 16: array[FONT_SIZE_PTR] = 1
		case 20: array[FONT_SIZE_PTR] = 2
	}
	unfuse_keybind(settingsdata.keybindings["up"],       array[KEY_MOVEUP        : KEY_MOVEDOWN])
	unfuse_keybind(settingsdata.keybindings["down"],     array[KEY_MOVEDOWN      : KEY_MOVELEFT])
	unfuse_keybind(settingsdata.keybindings["left"],     array[KEY_MOVELEFT      : KEY_MOVERIGHT])
	unfuse_keybind(settingsdata.keybindings["right"],    array[KEY_MOVERIGHT     : KEY_GRABMAP])
	unfuse_keybind(settingsdata.keybindings["grabmap"],  array[KEY_GRABMAP       : KEY_ZOOMPOS])
	unfuse_keybind(settingsdata.keybindings["zoompos"],  array[KEY_ZOOMPOS       : KEY_ZOOMNEG])
	unfuse_keybind(settingsdata.keybindings["zoomneg"],  array[KEY_ZOOMNEG       : KEY_DATE_PAUSE])

	unfuse_keybind(settingsdata.keybindings["pause"],    array[KEY_DATE_PAUSE    : KEY_DATE_FAST])
	unfuse_keybind(settingsdata.keybindings["faster"],   array[KEY_DATE_FAST     : KEY_DATE_SLOW])
	unfuse_keybind(settingsdata.keybindings["slower"],   array[KEY_DATE_SLOW     : KEY_MM_OVERWORLD])

	unfuse_keybind(settingsdata.keybindings["over"],     array[KEY_MM_OVERWORLD  : KEY_MM_POLITICAL])
	unfuse_keybind(settingsdata.keybindings["politic"],  array[KEY_MM_POLITICAL  : KEY_MM_TERRAIN])
	unfuse_keybind(settingsdata.keybindings["terrain"],  array[KEY_MM_TERRAIN    : KEY_MM_CONTROL])
	unfuse_keybind(settingsdata.keybindings["control"],  array[KEY_MM_CONTROL    : KEY_MM_POPULATION])
	unfuse_keybind(settingsdata.keybindings["pop"],      array[KEY_MM_POPULATION : KEY_MM_ANCESTRY])
	unfuse_keybind(settingsdata.keybindings["ancestry"], array[KEY_MM_ANCESTRY   : KEY_MM_CULTURE])
	unfuse_keybind(settingsdata.keybindings["culture"],  array[KEY_MM_CULTURE    : KEY_MM_RELIGION])
	unfuse_keybind(settingsdata.keybindings["religion"], array[KEY_MM_RELIGION   : 0x78])

	//* Save file
	res := os.write_entire_file(SETTINGS_LOCATION, array[:])
	if !res do logging.add_to_log(SETTING_SAVE_FAILURE)
	else    do logging.add_to_log(SETTING_SAVE_SUCCESS)
}