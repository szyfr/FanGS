package date


//= Imports
import "core:fmt"
import "core:strings"

import "../../graphics/worldmap"


//= Procedures
to_string :: proc() -> cstring {
	builder : strings.Builder = {}
	str := fmt.sbprintf(
		&builder,
		"%v %2v %2v",
		worldmap.data.date.year,
		worldmap.data.date.month,
		worldmap.data.date.day,
	)

	cstr := strings.clone_to_cstring(str)
	delete(str)

	return cstr
}