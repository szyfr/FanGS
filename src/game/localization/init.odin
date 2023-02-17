package localization


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"

import "../../game"
import "../../debug"


//= Constants
LOCAL_LOCATION         :: "data/localization/"
LOCAL_EXT              :: ".json"

ERR_LOCALIZATION_FIND  :: "[ERROR]:\tFailed to find localization file: "
ERR_LOCALIZATION_INFO  :: "\n\t\t\t |-- "
LOCALIZATION_LOADED    :: "[LOG]:\tLoaded localization strings.."


//= Global


//= Procedure

init :: proc() {
	game.localization = make(map[string]cstring, 10000)

	//* Generate path to file
	path := strings.concatenate({
		LOCAL_LOCATION,
		strings.clone_from_cstring(game.settings.language),
		LOCAL_EXT,
	})

	//* Check for localization file
	if !os.is_file(path) {
		error := strings.concatenate({
			ERR_LOCALIZATION_FIND,
			ERR_LOCALIZATION_INFO,
			strings.clone_from_cstring(game.settings.language),
			LOCAL_EXT,
		})
		debug.create(&game.errorHolder.errorArray, strings.clone_to_cstring(error), 1)
	}

	//* Load file
	rawdata, err := os.read_entire_file_from_filename(path)
	jsonData, er := json.parse(rawdata)

	//* Grab localization
	for value in jsonData.(json.Object) {
		game.localization[value] = strings.clone_to_cstring(jsonData.(json.Object)[value].(string))
	}

	//* Logging
	debug.create(&game.errorHolder.errorArray, LOCALIZATION_LOADED, 2)

	//* Cleanup
	delete(rawdata)
}

close :: proc() {
	delete(game.localization)
}