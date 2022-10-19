package gamedata


//= Imports
import "vendor:raylib"


//= Structures
NationData :: struct {
	localID :  i32,
	name    : ^cstring,
	color   : raylib.Color,

	//flag    : ^raylib.Texture,

	ownedProvinces : [dynamic]raylib.Color,
}