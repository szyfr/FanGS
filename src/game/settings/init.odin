package settings


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

import "../../debug"


//= Constants
SETTINGS_LOCATION   :: "data/settings.json"

SETTINGS_SCREENWIDTH  :: "screenwidth"
SETTINGS_SCREENHEIGHT :: "screenheight"
SETTINGS_TARGETFPS    :: "targetfps"
SETTINGS_EDGESCROLL   :: "edgescrolling"
SETTINGS_FONTSIZE     :: "fontsize"
SETTINGS_LANGUAGE     :: "language"
SETTINGS_KEYBINDINGS  :: "keybindings"
SETTINGS_MAPMODES     :: "mapmodes"

SETTINGS_ORIGIN     :: "origin"
SETTINGS_KEY        :: "key"

SETINGS_KEY_UP      :: "up"
SETINGS_KEY_DOWN    :: "down"
SETINGS_KEY_LEFT    :: "left"
SETINGS_KEY_RIGHT   :: "right"
SETINGS_KEY_GRABMAP :: "grabmap"
SETINGS_KEY_ZOOM_POSITIVE :: "zoompos"
SETINGS_KEY_ZOOM_NEGATIVE :: "zoomneg"
SETINGS_KEY_PAUSE   :: "pause"
SETINGS_KEY_FASTER  :: "faster"
SETINGS_KEY_SLOWER  :: "slower"
SETINGS_KEY_MM00    :: "mm00"
SETINGS_KEY_MM01    :: "mm01"
SETINGS_KEY_MM02    :: "mm02"
SETINGS_KEY_MM03    :: "mm03"
SETINGS_KEY_MM04    :: "mm04"
SETINGS_KEY_MM05    :: "mm05"
SETINGS_KEY_MM06    :: "mm06"
SETINGS_KEY_MM07    :: "mm07"
SETINGS_KEY_MM08    :: "mm08"
SETINGS_KEY_MM09    :: "mm09"

SETTINGS_MAPMODE_OVERWORLD      :: "overworld"
SETTINGS_MAPMODE_POLITICAL      :: "political"
SETTINGS_MAPMODE_TERRAIN        :: "terrain"
SETTINGS_MAPMODE_CONTROL        :: "control"
SETTINGS_MAPMODE_AUTONOMY       :: "autonomy"
SETTINGS_MAPMODE_POPULATION     :: "population"
SETTINGS_MAPMODE_INFRASTRUCTURE :: "infrastructure"
SETTINGS_MAPMODE_ANCESTRY       :: "ancestry"
SETTINGS_MAPMODE_CULTURE        :: "culture"
SETTINGS_MAPMODE_RELIGION       :: "religion"

SETTINGS_DEFAULT_LANGUAGE :: "english"

ERR_SETTINGS_FIND   :: "[ERROR]:\tFailed to find Settings file."
ERR_SETTINGS_LANG   :: "[ERROR]:\tInput language does not currently exist."
ERR_SETTINGS_ORIG   :: "[ERROR]:\tInput key lacks a valid origin."
SETTINGS_LOADED     :: "[LOG]:\tLoaded program settings."
SETTINGS_SAVED      :: "[LOG]:\tSaved program settings."


//= Procedures

//* Initialization
init :: proc() {

	//* Init structure
	data = new(SettingsData)

	//* Check for present file
	if !os.is_file(SETTINGS_LOCATION) {
		debug.add_to_log(ERR_SETTINGS_FIND)
		
		generate_default_settings()
		save_settings()

		return
	}

	//* Load file
	rawData, err := os.read_entire_file_from_filename(SETTINGS_LOCATION)
	jsonData, er := json.parse(rawData)

	//* Grab settings
	data.windowWidth   = i32(jsonData.(json.Object)[SETTINGS_SCREENWIDTH].(f64))
	data.windowHeight  = i32(jsonData.(json.Object)[SETTINGS_SCREENHEIGHT].(f64))
	data.targetFPS     = i32(jsonData.(json.Object)[SETTINGS_TARGETFPS].(f64))
	data.edgeScrolling =     jsonData.(json.Object)[SETTINGS_EDGESCROLL].(bool)
	data.fontSize      = f32(jsonData.(json.Object)[SETTINGS_FONTSIZE].(f64))
	data.language      = strings.clone_to_cstring(jsonData.(json.Object)[SETTINGS_LANGUAGE].(string))

	//* Grab keybindings
	obj := jsonData.(json.Object)[SETTINGS_KEYBINDINGS].(json.Object)
	data.keybindings[SETINGS_KEY_UP]            = create_keybinding(obj[SETINGS_KEY_UP].(json.Object))
	data.keybindings[SETINGS_KEY_DOWN]          = create_keybinding(obj[SETINGS_KEY_DOWN].(json.Object))
	data.keybindings[SETINGS_KEY_LEFT]          = create_keybinding(obj[SETINGS_KEY_LEFT].(json.Object))
	data.keybindings[SETINGS_KEY_RIGHT]         = create_keybinding(obj[SETINGS_KEY_RIGHT].(json.Object))
	data.keybindings[SETINGS_KEY_GRABMAP]       = create_keybinding(obj[SETINGS_KEY_GRABMAP].(json.Object))
	data.keybindings[SETINGS_KEY_ZOOM_POSITIVE] = create_keybinding(obj[SETINGS_KEY_ZOOM_POSITIVE].(json.Object))
	data.keybindings[SETINGS_KEY_ZOOM_NEGATIVE] = create_keybinding(obj[SETINGS_KEY_ZOOM_NEGATIVE].(json.Object))
	data.keybindings[SETINGS_KEY_PAUSE]         = create_keybinding(obj[SETINGS_KEY_PAUSE].(json.Object))
	data.keybindings[SETINGS_KEY_FASTER]        = create_keybinding(obj[SETINGS_KEY_FASTER].(json.Object))
	data.keybindings[SETINGS_KEY_SLOWER]        = create_keybinding(obj[SETINGS_KEY_SLOWER].(json.Object))
	data.keybindings[SETINGS_KEY_MM00]          = create_keybinding(obj[SETINGS_KEY_MM00].(json.Object))
	data.keybindings[SETINGS_KEY_MM01]          = create_keybinding(obj[SETINGS_KEY_MM01].(json.Object))
	data.keybindings[SETINGS_KEY_MM02]          = create_keybinding(obj[SETINGS_KEY_MM02].(json.Object))
	data.keybindings[SETINGS_KEY_MM03]          = create_keybinding(obj[SETINGS_KEY_MM03].(json.Object))
	data.keybindings[SETINGS_KEY_MM04]          = create_keybinding(obj[SETINGS_KEY_MM04].(json.Object))
	data.keybindings[SETINGS_KEY_MM05]          = create_keybinding(obj[SETINGS_KEY_MM05].(json.Object))
	data.keybindings[SETINGS_KEY_MM06]          = create_keybinding(obj[SETINGS_KEY_MM06].(json.Object))
	data.keybindings[SETINGS_KEY_MM07]          = create_keybinding(obj[SETINGS_KEY_MM07].(json.Object))
	data.keybindings[SETINGS_KEY_MM08]          = create_keybinding(obj[SETINGS_KEY_MM08].(json.Object))
	data.keybindings[SETINGS_KEY_MM09]          = create_keybinding(obj[SETINGS_KEY_MM09].(json.Object))

	//* Grab mapmodes
	arr := jsonData.(json.Object)[SETTINGS_MAPMODES].(json.Array)
	cnt := 0
	for a in arr {
		str := a.(string)
		
		switch str {
			case SETTINGS_MAPMODE_OVERWORLD:      data.mapmodesTool[cnt] = .overworld
			case SETTINGS_MAPMODE_POLITICAL:      data.mapmodesTool[cnt] = .political
			case SETTINGS_MAPMODE_TERRAIN:        data.mapmodesTool[cnt] = .terrain
			case SETTINGS_MAPMODE_CONTROL:        data.mapmodesTool[cnt] = .control
			case SETTINGS_MAPMODE_AUTONOMY:       data.mapmodesTool[cnt] = .autonomy
			case SETTINGS_MAPMODE_POPULATION:     data.mapmodesTool[cnt] = .population
			case SETTINGS_MAPMODE_INFRASTRUCTURE: data.mapmodesTool[cnt] = .infrastructure
			case SETTINGS_MAPMODE_ANCESTRY:       data.mapmodesTool[cnt] = .ancestry
			case SETTINGS_MAPMODE_CULTURE:        data.mapmodesTool[cnt] = .culture
			case SETTINGS_MAPMODE_RELIGION:       data.mapmodesTool[cnt] = .religion
		}
		cnt += 1
	}

	//* Logging
	debug.add_to_log(SETTINGS_LOADED)

	//* Cleanup
	delete(rawData)
	json.destroy_value(jsonData)
}

//* Close
close :: proc() {
	free(data)
}

//* Generate settings from defaults
generate_default_settings :: proc() {
	data.windowWidth   = 1280
	data.windowHeight  =  720
	data.targetFPS     =   80
	data.fontSize      =   12
	data.language      = SETTINGS_DEFAULT_LANGUAGE
	data.edgeScrolling = false

	data.keybindings[SETINGS_KEY_UP]       = {0,265,true}
	data.keybindings[SETINGS_KEY_DOWN]     = {0,264,true}
	data.keybindings[SETINGS_KEY_LEFT]     = {0,263,true}
	data.keybindings[SETINGS_KEY_RIGHT]    = {0,262,true}
	data.keybindings[SETINGS_KEY_GRABMAP]  = {1,2,true}
	data.keybindings[SETINGS_KEY_ZOOM_POSITIVE]  = {2,0,true}
	data.keybindings[SETINGS_KEY_ZOOM_NEGATIVE]  = {2,1,true}
	data.keybindings[SETINGS_KEY_PAUSE]    = {0,32,true}
	data.keybindings[SETINGS_KEY_FASTER]   = {0,61,true}
	data.keybindings[SETINGS_KEY_SLOWER]   = {0,45,true}
	data.keybindings[SETINGS_KEY_MM00]     = {0,48,true}
	data.keybindings[SETINGS_KEY_MM01]     = {0,49,true}
	data.keybindings[SETINGS_KEY_MM02]     = {0,50,true}
	data.keybindings[SETINGS_KEY_MM03]     = {0,51,true}
	data.keybindings[SETINGS_KEY_MM04]     = {0,52,true}
	data.keybindings[SETINGS_KEY_MM05]     = {0,53,true}
	data.keybindings[SETINGS_KEY_MM06]     = {0,54,true}
	data.keybindings[SETINGS_KEY_MM07]     = {0,55,true}
	data.keybindings[SETINGS_KEY_MM08]     = {0,56,true}
	data.keybindings[SETINGS_KEY_MM09]     = {0,57,true}
}

//* Save settings to file
//TODO Rework this
save_settings :: proc() {

	builder : strings.Builder = {}

	strings.write_string(&builder, "{\n")

	strings.write_string(&builder, "\t\"screenwidth\": ")
	strings.write_int(&builder, int(data.windowWidth))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"screenheight\": ")
	strings.write_int(&builder, int(data.windowHeight))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"targetfps\": ")
	strings.write_int(&builder, int(data.targetFPS))
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"language\": \"")
	strings.write_string(&builder, strings.clone_from_cstring(data.language))
	strings.write_string(&builder, "\",\n")

	strings.write_string(&builder, "\t\"edgescrolling\": ")
	if data.edgeScrolling do strings.write_string(&builder, "true")
	else                  do strings.write_string(&builder, "false")
	strings.write_string(&builder, ",\n")

	strings.write_string(&builder, "\t\"fontsize\": ")
	strings.write_int(&builder, int(data.fontSize))
	strings.write_string(&builder, ",\n\n")

	//* Keybindings
	strings.write_string(&builder, "\t\"keybindings\": {\n")

	strings.write_string(&builder, "\t\t\"up\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["up"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["up"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"down\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["down"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["down"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"left\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["left"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["left"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"right\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["right"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["right"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"grabmap\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["grabmap"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["grabmap"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"zoompos\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["zoompos"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["zoompos"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"zoomneg\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["zoomneg"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["zoomneg"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"pause\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["pause"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["pause"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"faster\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["faster"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["faster"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"slower\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["slower"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["slower"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm00\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm00"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm00"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm01\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm01"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm01"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm02\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm02"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm02"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm03\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm03"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm03"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm04\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm04"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm04"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm05\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm05"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm05"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm06\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm06"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm06"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm07\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm07"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm07"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm08\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm08"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm08"].key))
	strings.write_string(&builder, "\n\t\t},\n")

	strings.write_string(&builder, "\t\t\"mm09\": {")
	strings.write_string(&builder, "\n\t\t\t\"origin\": ")
	strings.write_int(&builder, int(data.keybindings["mm09"].origin))
	strings.write_string(&builder, ",\n\t\t\t\"key\": ")
	strings.write_int(&builder, int(data.keybindings["mm09"].key))
	strings.write_string(&builder, "\n\t\t}")

	strings.write_string(&builder, "\n\t}")


	strings.write_string(&builder, "\n}")


	os.write_entire_file(SETTINGS_LOCATION, builder.buf[:])

	debug.add_to_log(SETTINGS_SAVED)
}