package date


//= Imports
import "core:fmt"
import "core:strings"

import "../../game"


//= Procedures
to_string :: proc() -> cstring {
	builder : strings.Builder = {}
	str := fmt.sbprintf(
		&builder,
		"%v %2v %2v",
		game.worldmap.date.year,
		game.worldmap.date.month,
		game.worldmap.date.day,
	)

	cstr := strings.clone_to_cstring(str)
	delete(str)

	return cstr
}