package main



//= Imports
import "core:fmt"
import "core:strings"

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
	rawData: [^]u8;

	switch settings.language {
		case .english:
			if raylib.file_exists("data/localization/english.bin") {
				rawData = raylib.load_file_text("data/localization/english.bin");
			}
			break;
		case .spanish:
			if raylib.file_exists("data/localization/spanish.bin") {
				rawData = raylib.load_file_text("data/localization/spanish.bin");
			}
			break;
		case .german:
			if raylib.file_exists("data/localization/german.bin") {
				rawData = raylib.load_file_text("data/localization/german.bin");
			}
			break;
		case .french:
			if raylib.file_exists("data/localization/french.bin") {
				rawData = raylib.load_file_text("data/localization/french.bin");
			}
			break;
	}

	if rawData == nil {
		// TODO: report problem in log
		fmt.printf("Failed to load localization\n");
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

copy_string :: proc(array: [^]u8, offset: ^int) -> (string, int) {
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