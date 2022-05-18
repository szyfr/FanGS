package localization
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import fmt "core:fmt"
import str "core:strings"
import rl  "../../raylib"
import ut  "../utilities"


// Initializes Core localization
// TODO: Check settings for default language
// TODO: Move debug code
localization_creation_core :: proc() -> [dynamic]string {
	localData    : [dynamic]u8     = ut.load_raw_file("data/localization/english.bin");
	localStrings : [dynamic]string = make([dynamic]string, 0);


	// Error checking
	if len(localData) == 0 {
		// TODO: error
		return nil;
	}


	// Builds every string from localData
	builder : ^str.Builder = new(str.Builder);
	str.init_builder_len_cap(builder, 0, 32);

	for i:=0; i < len(localData); i+=1 {
		if localData[i] == 0x0A {
			append(&localStrings, string(builder.buf[:]));
			builder = new(str.Builder);
		} else {
			str.write_byte(builder, localData[i]);
		}
	}


	// Prints debug info
	// TODO: move to it's own debug package
	fmt.printf("\n\nLength:\t%i\n\nNumber of strings:\t%i\n", len(localData), len(localStrings));
	for i := 0; i < len(localStrings); i += 1 {
		fmt.printf("%i:\t%s\n", len(localStrings[i]), localStrings[i]);
	}


	// cleanup
	delete(localData);

	return localStrings;
}

// Initializes localization for map
// TODO: Move debug code
localization_creation_map  :: proc(mapname: string) -> [dynamic]string {
	localData    : [dynamic]u8     = ut.load_raw_file(mapname);
	localStrings : [dynamic]string = make([dynamic]string, 0);


	// Error checking
	if len(localData) == 0 {
		// TODO: error
		return nil;
	}


	// Builds every string from localData
	builder : ^str.Builder = new(str.Builder);
	str.init_builder_len_cap(builder, 0, 32);

	for i:=0; i < len(localData); i+=1 {
		if localData[i] == 0x0A {
			append(&localStrings, string(builder.buf[:]));
			builder = new(str.Builder);
		} else {
			str.write_byte(builder, localData[i]);
		}
	}


	// Prints debug info
	// TODO: move to it's own debug package
	fmt.printf("\n\nLength:\t%i\n\nNumber of strings:\t%i\n", len(localData), len(localStrings));
	for i := 0; i < len(localStrings); i += 1 {
		fmt.printf("%i:\t%s\n", len(localStrings[i]), localStrings[i]);
	}


	// cleanup
	delete(localData);

	return localStrings;
}