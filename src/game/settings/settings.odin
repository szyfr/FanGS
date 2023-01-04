package settings


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"
import "core:encoding/json"

import "../../debug"


//= Constants
SETTINGS_LOCATION  :: "data/settings.json"

ERR_SETTINGS_FIND  :: "[ERROR]:\tFailed to find Settings file."
ERR_SETTINGS_LANG  :: "[ERROR]:\tInput language does not currently exist."
SETTINGS_LOADED    :: "[LOG]:\tLoaded program settings."
SETTINGS_SAVED     :: "[LOG]:\tSaved program settings."


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
	data.windowWidth   = i32(jsonData.(json.Object)["screenwidth"].(f64))
	data.windowHeight  = i32(jsonData.(json.Object)["screenheight"].(f64))
	data.targetFPS     = i32(jsonData.(json.Object)["targetfps"].(f64))
	data.edgeScrolling =     jsonData.(json.Object)["edgescrolling"].(bool)
	data.fontSize      = f32(jsonData.(json.Object)["fontsize"].(f64))
	data.language      = strings.clone_to_cstring(jsonData.(json.Object)["language"].(string))

	//* Grab keybindings
	obj := jsonData.(json.Object)["keybindings"].(json.Object)
	data.keybindings["up"]       = create_keybinding(obj["up"].(json.Object))
	data.keybindings["down"]     = create_keybinding(obj["down"].(json.Object))
	data.keybindings["left"]     = create_keybinding(obj["left"].(json.Object))
	data.keybindings["right"]    = create_keybinding(obj["right"].(json.Object))
	data.keybindings["grabmap"]  = create_keybinding(obj["grabmap"].(json.Object))
	data.keybindings["zoompos"]  = create_keybinding(obj["zoompos"].(json.Object))
	data.keybindings["zoomneg"]  = create_keybinding(obj["zoomneg"].(json.Object))
	data.keybindings["pause"]    = create_keybinding(obj["pause"].(json.Object))
	data.keybindings["faster"]   = create_keybinding(obj["faster"].(json.Object))
	data.keybindings["slower"]   = create_keybinding(obj["slower"].(json.Object))
	data.keybindings["mm00"]     = create_keybinding(obj["mm00"].(json.Object))
	data.keybindings["mm01"]     = create_keybinding(obj["mm01"].(json.Object))
	data.keybindings["mm02"]     = create_keybinding(obj["mm02"].(json.Object))
	data.keybindings["mm03"]     = create_keybinding(obj["mm03"].(json.Object))
	data.keybindings["mm04"]     = create_keybinding(obj["mm04"].(json.Object))
	data.keybindings["mm05"]     = create_keybinding(obj["mm05"].(json.Object))
	data.keybindings["mm06"]     = create_keybinding(obj["mm06"].(json.Object))
	data.keybindings["mm07"]     = create_keybinding(obj["mm07"].(json.Object))
	data.keybindings["mm08"]     = create_keybinding(obj["mm08"].(json.Object))
	data.keybindings["mm09"]     = create_keybinding(obj["mm09"].(json.Object))

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
	data.language      = "english"
	data.edgeScrolling = false

	data.keybindings["up"]       = {0,265}
	data.keybindings["down"]     = {0,264}
	data.keybindings["left"]     = {0,263}
	data.keybindings["right"]    = {0,262}
	data.keybindings["grabmap"]  = {1,2}
	data.keybindings["zoompos"]  = {2,0}
	data.keybindings["zoomneg"]  = {2,1}
	data.keybindings["pause"]    = {0,32}
	data.keybindings["faster"]   = {0,61}
	data.keybindings["slower"]   = {0,45}
	data.keybindings["mm00"]     = {0,48}
	data.keybindings["mm01"]     = {0,49}
	data.keybindings["mm02"]     = {0,50}
	data.keybindings["mm03"]     = {0,51}
	data.keybindings["mm04"]     = {0,52}
	data.keybindings["mm05"]     = {0,53}
	data.keybindings["mm06"]     = {0,54}
	data.keybindings["mm07"]     = {0,55}
	data.keybindings["mm08"]     = {0,56}
	data.keybindings["mm09"]     = {0,57}
}

//* Save settings to file
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