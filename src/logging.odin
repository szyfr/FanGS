package main



//= Imports
import "core:fmt"
import "core:bytes"

import "raylib"


//= Constants

//= Global Variables
outputLog: [dynamic]string;


//= Structures

//= Enumerations

//= Procedures
add_to_log :: proc(input: string) {
	append(&outputLog, input);
}

print_log :: proc() {

	buffer: bytes.Buffer = {};

	for i:=0; i<len(outputLog); i+=1 {
		bytes.buffer_write_string(&buffer, outputLog[i]);
		bytes.buffer_write_byte(&buffer, '\n');
	}
	bytes.buffer_write_byte(&buffer, 0);

	output := bytes.buffer_to_bytes(&buffer);
	fmt.printf("%s",output)

	raylib.save_file_text("data/log.txt", &output[0]);

	delete(output);
}