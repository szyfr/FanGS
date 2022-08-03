package main



//= Imports
import "core:fmt"
import "core:strings"
import "core:os"

import "raylib"

//= Constants

//= Global Variables
localization: ^Localization;


//= Structures
Localization :: struct {
	// Main menu
	newGame, loadGame, mods, options, quit: string,
}

//= Enumerations

//= Procedures
init_localization :: proc() {
	localization = new(Localization);
	rawData: []u8;
	success: bool;

	switch settings.language {
		case .english:
			if os.is_file("data/localization/english.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/english.bin");
			}
			break;
		case .spanish:
			if os.is_file("data/localization/spanish.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/spanish.bin");
			}
			break;
		case .german:
			if os.is_file("data/localization/german.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/german.bin");
			}
			break;
		case .french:
			if os.is_file("data/localization/french.bin") {
				rawData, success = os.read_entire_file_from_filename("data/localization/french.bin");
			}
			break;
	}

	if rawData == nil || success == false {
		add_to_log("[Major]: Failed to load localization.");
		return;
	}

	offset: int = 0;

	localization.newGame,  offset = copy_string(rawData, &offset);
	localization.loadGame, offset = copy_string(rawData, &offset);
	localization.mods,     offset = copy_string(rawData, &offset);
	localization.options,  offset = copy_string(rawData, &offset);
	localization.quit,     offset = copy_string(rawData, &offset);
}
free_localization :: proc() {
	delete(localization.newGame);
	delete(localization.loadGame);
	delete(localization.mods);
	delete(localization.options);
	delete(localization.quit);

	free(localization);
}

copy_string :: proc(array: []u8, offset: ^int) -> (string, int) {
	builder: strings.Builder;

	for i:=offset^; array[i]!=0; i+=1 {
		offset^ += 1;

		if array[i] == 10 do break;

		strings.write_byte(&builder, array[i]);
	}

	str: string = strings.clone(strings.to_string(builder));

	strings.reset_builder(&builder);

	return str, offset^;
}