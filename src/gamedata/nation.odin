package gamedata


//= Imports
import "vendor:raylib"


//= Structures
NationData :: struct {
	localID        :  i32,
	name           : ^cstring,
	color          :  raylib.Color,

	centerpoint    :  raylib.Vector3,
	nametx         :  raylib.Texture,

	//flag    : ^raylib.Texture,

	ownedProvinces :  [dynamic]raylib.Color,
}