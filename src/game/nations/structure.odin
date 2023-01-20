package nations


//= Imports
import "vendor:raylib"


//= Structures
Nation :: struct {
	localID        :  string,
	name           : ^cstring,
	color          :  raylib.Color,

	centerpoint    :  raylib.Vector3,
	nametx         :  raylib.Texture,

	//flag    : ^raylib.Texture,

	ownedProvinces :  [dynamic]raylib.Color,
}