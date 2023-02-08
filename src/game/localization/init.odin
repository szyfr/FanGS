package localization


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:strings"
import "../settings"
import "../../debug"


//= Constants
LOCAL_LOCATION         :: "data/localization/"
LOCAL_EXT              :: ".json"

ERR_LOCALIZATION_FIND  :: "[ERROR]:\tFailed to find localization file: "
ERR_LOCALIZATION_INFO  :: "\n\t\t\t |-- "
LOCALIZATION_LOADED    :: "[LOG]:\tLoaded localization strings.."


//= Global
data : map[string]cstring


//= Procedure

init :: proc() {
	data = make(map[string]cstring, 10000)

	//* Generate path to file
	builder : strings.Builder
	strings.write_string(&builder, LOCAL_LOCATION)
	strings.write_string(&builder, strings.clone_from_cstring(settings.data.language))
	strings.write_string(&builder, LOCAL_EXT)
	location := strings.to_string(builder)

	//* Check for localization file
	if !os.is_file(location) {
		builderdebug : strings.Builder
		strings.write_string(&builderdebug, ERR_LOCALIZATION_FIND)
		strings.write_string(&builderdebug, ERR_LOCALIZATION_INFO)
		strings.write_string(&builderdebug, strings.clone_from_cstring(settings.data.language))
		strings.write_string(&builderdebug, LOCAL_EXT)
		debug.add_to_log(strings.to_string(builderdebug))
	}

	//* Load file
	rawdata, err := os.read_entire_file_from_filename(location)
	jsonData, er := json.parse(rawdata)

	//* Grab localization
	for value in jsonData.(json.Object) {
		data[value] = strings.clone_to_cstring(jsonData.(json.Object)[value].(string))
	}

	//* Logging
	debug.add_to_log(LOCALIZATION_LOADED)

	//* Cleanup
	delete(rawdata)
}

close :: proc() {
	delete(data)
}