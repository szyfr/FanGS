package localization


//= Imports
import "core:os"

import "../logging"
import "../gamedata"


//= Procedures
// TODO: Fix the language bullshit i've done here
init :: proc(lang : i32) {
	using gamedata

	localizationdata = new(gamedata.LocalizationData)
	rawData : []u8
	success : bool

	switch lang {
		case 0:
			if os.is_file("data/localization/english.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/english.bin")
			}
			break
		case 1:
			if os.is_file("data/localization/spanish.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/spanish.bin")
			}
			break;
		case 2:
			if os.is_file("data/localization/german.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/german.bin")
			}
			break
		case 3:
			if os.is_file("data/localization/french.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/french.bin")
			}
			break
	}

	if rawData == nil || success == false {
		logging.add_to_log("[Major]: Failed to load localization.")
		return
	}

	offset : int = 0

	localizationdata.newGame,  offset = copy_string(rawData, &offset)
	localizationdata.loadGame, offset = copy_string(rawData, &offset)
	localizationdata.mods,     offset = copy_string(rawData, &offset)
	localizationdata.options,  offset = copy_string(rawData, &offset)
	localizationdata.quit,     offset = copy_string(rawData, &offset)
}
free_data :: proc() {
	delete(gamedata.localizationdata.newGame)
	delete(gamedata.localizationdata.loadGame)
	delete(gamedata.localizationdata.mods)
	delete(gamedata.localizationdata.options)
	delete(gamedata.localizationdata.quit)

	free(gamedata.localizationdata)
}