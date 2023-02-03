package population


//= Imports
import "vendor:raylib"


//= Structures
Ancestry :: struct {
	name   : ^cstring,
	growth : f32,
	color  : raylib.Color,
}
Culture :: struct {
	name     : ^cstring,
	ancestry : ^Ancestry,
	color  : raylib.Color,
}
Religion :: struct {
	name : ^cstring,
	color  : raylib.Color,
}

Population :: struct {
	count : u64,

	ancestry : ^Ancestry,
	culture  : ^Culture,
	religion : ^Religion,
}