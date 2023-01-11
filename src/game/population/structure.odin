package population


//= Imports
import "vendor:raylib"


//= Structures
Ancestry :: struct {
	name : ^cstring,
}
Culture :: struct {
	name     : ^cstring,
	ancestry : ^Ancestry,
}
Religion :: struct {
	name : ^cstring,
}