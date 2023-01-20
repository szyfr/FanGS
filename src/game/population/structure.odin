package population


//= Imports
import "vendor:raylib"


//= Structures
Ancestry :: struct {
	name   : ^cstring,
	growth : f32,
}
Culture :: struct {
	name     : ^cstring,
	ancestry : ^Ancestry,
}
Religion :: struct {
	name : ^cstring,
}

Population :: struct {
	count : u64,

	ancestry : ^Ancestry,
	culture  : ^Culture,
	religion : ^Religion,
}