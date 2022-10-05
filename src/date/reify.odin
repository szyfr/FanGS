package date


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../gamedata"
import "../worldmap"


//= Constants


//= Procedures
to_string :: proc() -> cstring {
	builder : strings.Builder = {}
	str := fmt.sbprintf(
		&builder,
		"%v %2v %2v",
		gamedata.worlddata.date.year,
		gamedata.worlddata.date.month,
		gamedata.worlddata.date.day,
	)

	cstr := strings.clone_to_cstring(str)
	delete(str)

	return cstr
}