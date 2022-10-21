package localization


//= Imports
import "core:fmt"
import "core:os"
import "core:strings"

import "../logging"
import "../gamedata"


//= Constants
LANG_ENG_LOCATION :: "data/localization/english.bin"
LANG_SPA_LOCATION :: "data/localization/spanish.bin"
LANG_GER_LOCATION :: "data/localization/german.bin"
LANG_FRA_LOCATION :: "data/localization/french.bin"

LOCAL_LOAD_FAILURE :: "[Major]: Failed to load localization."
LOCAL_LOAD_SUCCESS :: "[LOG]: Loaded core localization."

MISSING_STRING :: "missing_string"

MODS_LOCATION_START   :: "data/mods/"
MODS_LOCATION_DEF_ENG :: "/localization/english.bin"
MODS_LOCATION_DEF_SPA :: "/localization/spanish.bin"
MODS_LOCATION_DEF_GER :: "/localization/german.bin"
MODS_LOCATION_DEF_FRA :: "/localization/french.bin"

MODS_LOCATION_TER_ENG :: "/localization/terrain/english.bin"
MODS_LOCATION_TER_SPA :: "/localization/terrain/spanish.bin"
MODS_LOCATION_TER_GER :: "/localization/terrain/german.bin"
MODS_LOCATION_TER_FRA :: "/localization/terrain/french.bin"

MODS_LOCATION_PRO_ENG :: "/localization/provinces/english.bin"
MODS_LOCATION_PRO_SPA :: "/localization/provinces/spanish.bin"
MODS_LOCATION_PRO_GER :: "/localization/provinces/german.bin"
MODS_LOCATION_PRO_FRA :: "/localization/provinces/french.bin"

MODS_LOCATION_NAT_ENG :: "/localization/nations/english.bin"
MODS_LOCATION_NAT_SPA :: "/localization/nations/spanish.bin"
MODS_LOCATION_NAT_GER :: "/localization/nations/german.bin"
MODS_LOCATION_NAT_FRA :: "/localization/nations/french.bin"


//= Procedures

//* Initialization
init :: proc(lang : gamedata.Languages) {
	using gamedata

	//* Initialize structures and variables
	localizationdata = new(gamedata.LocalizationData)
	rawData : []u8
	success : bool

	//* Load specified language file
	#partial switch lang {
		case .english:
			if os.is_file(LANG_ENG_LOCATION) do rawData, success = os.read_entire_file_from_filename(LANG_ENG_LOCATION)
		case .spanish:
			if os.is_file(LANG_SPA_LOCATION) do rawData, success = os.read_entire_file_from_filename(LANG_SPA_LOCATION)
		case .german:
			if os.is_file(LANG_GER_LOCATION) do rawData, success = os.read_entire_file_from_filename(LANG_GER_LOCATION)
		case .french:
			if os.is_file(LANG_FRA_LOCATION) do rawData, success = os.read_entire_file_from_filename(LANG_FRA_LOCATION)
	}

	//* Make sure file loaded
	if rawData == nil || success == false {
		logging.add_to_log(LOCAL_LOAD_FAILURE)
		return
	} else do logging.add_to_log(LOCAL_LOAD_SUCCESS)

	offset : int = 0

	//* Load strings
	localizationdata.newGame,      offset = copy_string(rawData, &offset)
	localizationdata.loadGame,     offset = copy_string(rawData, &offset)
	localizationdata.mods,         offset = copy_string(rawData, &offset)
	localizationdata.options,      offset = copy_string(rawData, &offset)
	localizationdata.quit,         offset = copy_string(rawData, &offset)
	localizationdata.title,        offset = copy_string(rawData, &offset)
	localizationdata.resume,       offset = copy_string(rawData, &offset)
	localizationdata.save,         offset = copy_string(rawData, &offset)
	localizationdata.mainmenu,     offset = copy_string(rawData, &offset)
	
	localizationdata.provTypes[0], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[1], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[2], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[3], offset = copy_string(rawData, &offset)
	localizationdata.provTypes[4], offset = copy_string(rawData, &offset)

	localizationdata.missing = MISSING_STRING
}

//* Free
free_data :: proc() {
	using gamedata

	delete(localizationdata.newGame)
	delete(localizationdata.loadGame)
	delete(localizationdata.mods)
	delete(localizationdata.options)
	delete(localizationdata.quit)
	delete(localizationdata.title)
//	delete(localizationdata.missing) //! For some reason this hits a breakpoint.
	delete(localizationdata.worldLocalization)

	free(localizationdata)
}

load_mod :: proc(mod : string) {
	using gamedata

	directory : string
	rawData   : []u8
	success   : bool
	offset    : int = 0
	count     : int = 0
	total     : int = 0

	append(&localizationdata.baseLocalIndex,      u32(len(localizationdata.baseLocalArray)))
	append(&localizationdata.terrainLocalIndex,   u32(len(localizationdata.terrainLocalArray)))
	append(&localizationdata.provincesLocalIndex, u32(len(localizationdata.provincesLocalArray)))

	//* Base
	#partial switch gamedata.settingsdata.language {
		case .english:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_DEF_ENG})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .spanish:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_DEF_SPA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .german:
			directory = strings.concatenate({MODS_LOCATION_START, mod,MODS_LOCATION_DEF_GER})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .french:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_DEF_FRA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
	}
	offset = 0
	count  = count_strings(rawData)
	for i:=0;i<count-1;i+=1 {
		local : cstring
		local, offset = copy_string(rawData, &offset)

		append(&localizationdata.baseLocalArray, local)
	}
	total += count
	delete(rawData)

	//* Terrain
	#partial switch settingsdata.language {
		case .english:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_TER_ENG})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .spanish:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_TER_SPA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .german:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_TER_GER})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .french:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_TER_FRA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
	}
	offset = 0
	count  = count_strings(rawData)
	for i:=0;i<count-1;i+=1 {
		local : cstring
		local, offset = copy_string(rawData, &offset)

		append(&localizationdata.terrainLocalArray, local)
	}
	total += count
	delete(rawData)

	//* Provinces
	#partial switch settingsdata.language {
		case .english:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_PRO_ENG})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .spanish:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_PRO_SPA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .german:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_PRO_GER})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .french:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_PRO_FRA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
	}
	offset = 0
	count  = count_strings(rawData)
	for i:=0;i<count-1;i+=1 {
		local : cstring
		local, offset = copy_string(rawData, &offset)

		append(&gamedata.localizationdata.provincesLocalArray, local)
	}
	total += count
	delete(rawData)

	//* Nations
	#partial switch settingsdata.language {
		case .english:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_NAT_ENG})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .spanish:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_NAT_SPA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .german:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_NAT_GER})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
		case .french:
			directory = strings.concatenate({MODS_LOCATION_START, mod, MODS_LOCATION_NAT_FRA})
			if os.is_file(directory) do rawData, success = os.read_entire_file_from_filename(directory)
	}
	offset = 0
	count  = count_strings(rawData)
	for i:=0;i<count-1;i+=1 {
		local : cstring
		local, offset = copy_string(rawData, &offset)

		append(&gamedata.localizationdata.nationsLocalArray, local)
	}
	total += count
	delete(rawData)

	//* Logging
	builder : strings.Builder
	str     := fmt.sbprintf(
		&builder,
		"[LOG]: Loaded %v strings from mod:(%s).",
		total,
		mod,
	)
	logging.add_to_log(str)
	delete(str)
}