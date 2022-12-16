package settings


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

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
	
//	//* Check for file and load
//	if !os.is_file(SETTINGS_LOCATION) do create_settings()
//	rawData, err := os.read_entire_file_from_filename(SETTINGS_LOCATION)
//
//	//* Grab settings
//	settingsdata.windowWidth   = fuse_i32(rawData, WINDOW_WIDTH_PTR)
//	settingsdata.windowHeight  = fuse_i32(rawData, WINDOW_HEIGHT_PTR)
//	settingsdata.targetFPS     = fuse_i32(rawData, TARGET_FPS_PTR)
//	settingsdata.language      = gamedata.Languages(fuse_i32(rawData, LANGUAGE_PTR))
//	settingsdata.edgeScrolling = bool(rawData[EDGE_SCROLLING_PTR])
//	switch rawData[FONT_SIZE_PTR] {
//		case 0: settingsdata.fontSize = FONT_SIZE_SMALL
//		case 1: settingsdata.fontSize = FONT_SIZE_MED
//		case 2: settingsdata.fontSize = FONT_SIZE_LARGE
//	}
//
//	//* Grab keybindings
//	settingsdata.keybindings["up"]       = fuse_keybind(rawData, KEY_MOVEUP)
//	settingsdata.keybindings["down"]     = fuse_keybind(rawData, KEY_MOVEDOWN)
//	settingsdata.keybindings["left"]     = fuse_keybind(rawData, KEY_MOVELEFT)
//	settingsdata.keybindings["right"]    = fuse_keybind(rawData, KEY_MOVERIGHT)
//	settingsdata.keybindings["grabmap"]  = fuse_keybind(rawData, KEY_GRABMAP)
//	settingsdata.keybindings["zoompos"]  = fuse_keybind(rawData, KEY_ZOOMPOS)
//	settingsdata.keybindings["zoomneg"]  = fuse_keybind(rawData, KEY_ZOOMNEG)
//
//	settingsdata.keybindings["pause"]    = fuse_keybind(rawData, KEY_DATE_PAUSE)
//	settingsdata.keybindings["faster"]   = fuse_keybind(rawData, KEY_DATE_FAST)
//	settingsdata.keybindings["slower"]   = fuse_keybind(rawData, KEY_DATE_SLOW)
//
//	settingsdata.keybindings["over"]     = fuse_keybind(rawData, KEY_MM_OVERWORLD)
//	settingsdata.keybindings["politic"]  = fuse_keybind(rawData, KEY_MM_POLITICAL)
//	settingsdata.keybindings["terrain"]  = fuse_keybind(rawData, KEY_MM_TERRAIN)
//	settingsdata.keybindings["control"]  = fuse_keybind(rawData, KEY_MM_CONTROL)
//	settingsdata.keybindings["pop"]      = fuse_keybind(rawData, KEY_MM_POPULATION)
//	settingsdata.keybindings["ancestry"] = fuse_keybind(rawData, KEY_MM_ANCESTRY)
//	settingsdata.keybindings["culture"]  = fuse_keybind(rawData, KEY_MM_CULTURE)
//	settingsdata.keybindings["religion"] = fuse_keybind(rawData, KEY_MM_RELIGION)
//
//	//* Logging
//	logging.add_to_log("[LOG]: Loaded program settings.")
//


	//* Check for file and load
	// TODO: change create
	if !os.is_file("data/settings.json") do logging.add_to_log("[LOG]: Failed to find Settings file.")
	rawData, err := os.read_entire_file_from_filename("data/settings.json")
	data,er := json.parse(rawData)

	//* Grab settings
	settingsdata.windowWidth   = i32(data.(json.Object)["screenwidth"].(f64))
	settingsdata.windowHeight  = i32(data.(json.Object)["screenheight"].(f64))
	settingsdata.targetFPS     = i32(data.(json.Object)["targetfps"].(f64))
	settingsdata.edgeScrolling =     data.(json.Object)["edgescrolling"].(bool)
	settingsdata.fontSize      = f32(data.(json.Object)["fontsize"].(f64))
	switch data.(json.Object)["language"].(string) {
		case "english": settingsdata.language = Languages.english ; break
		case "spanish": settingsdata.language = Languages.spanish ; break
		case "german" : settingsdata.language = Languages.german  ; break
		case "french" : settingsdata.language = Languages.french  ; break
		case:
			settingsdata.language = Languages.english
			logging.add_to_log("[LOG]: Input language does not currently exist.")
			break

	}

	//* Grab keybindings
	obj := data.(json.Object)["keybindings"].(json.Object)
	settingsdata.keybindings["up"]       = create_keybinding(obj["moveup"].(json.Object))
	settingsdata.keybindings["down"]     = create_keybinding(obj["movedown"].(json.Object))
	settingsdata.keybindings["left"]     = create_keybinding(obj["moveleft"].(json.Object))
	settingsdata.keybindings["right"]    = create_keybinding(obj["moveright"].(json.Object))
	settingsdata.keybindings["grabmap"]  = create_keybinding(obj["grabmap"].(json.Object))
	settingsdata.keybindings["zoompos"]  = create_keybinding(obj["zoompos"].(json.Object))
	settingsdata.keybindings["zoomneg"]  = create_keybinding(obj["zoomneg"].(json.Object))
	settingsdata.keybindings["pause"]    = create_keybinding(obj["datepause"].(json.Object))
	settingsdata.keybindings["faster"]   = create_keybinding(obj["datefast"].(json.Object))
	settingsdata.keybindings["slower"]   = create_keybinding(obj["dateslow"].(json.Object))
	settingsdata.keybindings["over"]     = create_keybinding(obj["mm00"].(json.Object)) //TODO
	settingsdata.keybindings["politic"]  = create_keybinding(obj["mm01"].(json.Object)) //TODO
	settingsdata.keybindings["terrain"]  = create_keybinding(obj["mm02"].(json.Object)) //TODO
	settingsdata.keybindings["control"]  = create_keybinding(obj["mm03"].(json.Object)) //TODO
	settingsdata.keybindings["pop"]      = create_keybinding(obj["mm04"].(json.Object)) //TODO
	settingsdata.keybindings["ancestry"] = create_keybinding(obj["mm05"].(json.Object)) //TODO
	settingsdata.keybindings["culture"]  = create_keybinding(obj["mm06"].(json.Object)) //TODO
	settingsdata.keybindings["religion"] = create_keybinding(obj["mm07"].(json.Object)) //TODO
	settingsdata.keybindings["mm08"]     = create_keybinding(obj["mm08"].(json.Object))
	settingsdata.keybindings["mm09"]     = create_keybinding(obj["mm09"].(json.Object))

	//* Logging
	logging.add_to_log("[LOG]: Loaded program settings.")

	//* Cleanup
	delete(rawData)
	json.destroy_value(data)

//	fmt.printf("%v\n",i64(data.(json.Object)["targetfps"].(f64)))
}

//* Freeing
free_data :: proc() {
	free(gamedata.settingsdata)
}