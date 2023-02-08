package nations


//= Imports
import "vendor:raylib"


//= Structures
Nation :: struct {
	localID        :  string,
	color          :  raylib.Color,

	flag           :  raylib.Texture2D,

	centerpoint    :  raylib.Vector3,
	nametx         :  raylib.Texture,

	//flag    : ^raylib.Texture,

	ownedProvinces :  [dynamic]raylib.Color,
}