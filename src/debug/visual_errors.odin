package debug


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"


//= Constants
FONT_SIZE		:: 20
TEST_POSITION	:: 15


//= Structures
DebugError :: struct {
	errorText	: cstring,
	duration	: int,
	alertLevel	: int,
}
ArrayHolder :: struct {
	errorArray : [dynamic]DebugError,
}


//= Procedures
draw :: proc(
	holder		: ^ArrayHolder,
	alertLevel	:  int,
) {
	for i:=0;i<len(holder.errorArray);i+=1 {
		if holder.errorArray[i].alertLevel <= alertLevel {
			height := raylib.GetScreenHeight()
			error  := &holder.errorArray[i]
			color  : raylib.Color = {255,0,0,255}
			if error.duration < 100 do color.a = u8(255 * (f32(error.duration) / 100))
			raylib.DrawText(
				error.errorText,
				TEST_POSITION, i32(height - ((FONT_SIZE + TEST_POSITION) * (i32(i) + 1) )),
				FONT_SIZE,
				color,
			)
		}

		holder.errorArray[i].duration -= 1
	}

	temp := make([dynamic]DebugError)
	for error in holder.errorArray do if error.duration >= 1 do append(&temp, error)
	delete(holder.errorArray)
	holder.errorArray = temp
}

create :: proc{ create_complex }
create_base :: proc(
	errorText	: cstring,
	duration	: int = 500,
) -> DebugError {
	error : DebugError = {}

	error.errorText = errorText
	error.duration  = duration

	add_to_log(strings.clone_from_cstring(errorText))

	return error
}
create_complex :: proc(
	list		: ^[dynamic]DebugError,
	errorText	:  cstring,
	alertLevel	:  int,
	duration	:  int = 500,
) {
	error : DebugError = {}
	error.errorText		= errorText
	error.duration		= duration
	error.alertLevel	= alertLevel
	
	add_to_log(strings.clone_from_cstring(errorText))

	append(list, error)
}