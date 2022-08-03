package localization


//= Imports
import "core:os"


//= Procedures
// TODO: Fix the language bullshit i've done here
init :: proc(lang : i32) -> ^LocalizationData {
	localization := new(LocalizationData)
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
	//	add_to_log("[Major]: Failed to load localization.")
		return nil
	}

	offset : int = 0

	localization.newGame,  offset = copy_string(rawData, &offset)
	localization.loadGame, offset = copy_string(rawData, &offset)
	localization.mods,     offset = copy_string(rawData, &offset)
	localization.options,  offset = copy_string(rawData, &offset)
	localization.quit,     offset = copy_string(rawData, &offset)

	return localization
}
free_data :: proc(localization : ^LocalizationData) {
	delete(localization.newGame)
	delete(localization.loadGame)
	delete(localization.mods)
	delete(localization.options)
	delete(localization.quit)

	free(localization)
}