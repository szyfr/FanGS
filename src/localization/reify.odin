package localization


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"

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

	localizationdata.newGame,      offset = copy_string(rawData, &offset)
	localizationdata.loadGame,     offset = copy_string(rawData, &offset)
	localizationdata.mods,         offset = copy_string(rawData, &offset)
	localizationdata.options,      offset = copy_string(rawData, &offset)
	localizationdata.quit,         offset = copy_string(rawData, &offset)
	localizationdata.title,        offset = copy_string(rawData, &offset)
	
	localizationdata.provTypes[0], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[1], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[2], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[3], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[4], offset = copy_string(rawData, &offset)

	localizationdata.missing          = "missing_string"
}
free_data :: proc() {
	delete(gamedata.localizationdata.newGame)
	delete(gamedata.localizationdata.loadGame)
	delete(gamedata.localizationdata.mods)
	delete(gamedata.localizationdata.options)
	delete(gamedata.localizationdata.quit)
	delete(gamedata.localizationdata.title)
//	delete(gamedata.localizationdata.missing)
	delete(gamedata.localizationdata.worldLocalization)

	free(gamedata.localizationdata)
}

load_mod :: proc(mod : string) {
	directory : string
	rawData   : []u8
	success   : bool

	#partial switch gamedata.settingsdata.language {
		case .english:
			directory = strings.concatenate({"data/mods/", mod, "/localization/english.bin"})
			if os.is_file(directory) {
				rawData, success = os.read_entire_file_from_filename(directory)
			}
		case .spanish:
			directory = strings.concatenate({"data/mods/", mod, "/localization/spanish.bin"})
			if os.is_file(directory) {
				rawData, success = os.read_entire_file_from_filename(directory)
			}
		case .german:
			directory = strings.concatenate({"data/mods/", mod, "/localization/german.bin"})
			if os.is_file(directory) {
				rawData, success = os.read_entire_file_from_filename(directory)
			}
		case .french:
			directory = strings.concatenate({"data/mods/", mod, "/localization/french.bin"})
			if os.is_file(directory) {
				rawData, success = os.read_entire_file_from_filename(directory)
			}
	}

	offset : int = 0

	count := count_strings(rawData)

	for i:=0;i<count-1;i+=1 {
		local : cstring
		local, offset = copy_string(rawData, &offset)

		append(&gamedata.localizationdata.worldLocalization, local)
	}

	builder : strings.Builder
	str     := fmt.sbprintf(
		&builder,
		"[LOG]: Loaded %v strings from mod:(%s).",
		count,
		mod,
	)
	logging.add_to_log(str)
}