package utilities
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import fmt "core:fmt"
import str "core:strings"
import rl  "../../raylib"



// Loads named file
load_raw_file :: proc(sFilename: string) -> [dynamic]u8 {
	output: [dynamic]u8 = make([dynamic]u8, 0);
	csFilename: cstring = str.unsafe_string_to_cstring(sFilename);

	// Reads file
	bytesRead: u32 = 0;
	rawData: [^]u8 = rl.load_file_data(csFilename, &bytesRead);

	// Transfers rawData to output array
	for i := 0; i < int(bytesRead); i += 1 do append(&output, rawData[i]);

	// deallocating rawData
	rl.unload_file_data(rawData);

	return output;
}

// 
load_text_file :: proc(filename: cstring) -> [dynamic]u8 {
	output: [dynamic]u8 = make([dynamic]u8, 0);

	bytesRead: u32 = 0;
	rawData: [^]u8 = rl.load_file_data(filename, &bytesRead);

	return nil;
}