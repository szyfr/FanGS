package gamedata


//= Imports
import "core:math/linalg"
import "vendor:raylib"


//= Constants
MAT_ROTATE :: linalg.Matrix4x4f32 {
	-1, 0,  0, 0,
	 0, 1,  0, 0,
	 0, 0, -1, 0,
	 0, 0,  0, 1,
}
MAT_SCALE :: linalg.Matrix4x4f32 {
	 1, 0, 0, 0,
	 0, 5, 0, 0,
	 0, 0, 1, 0,
	 0, 0, 0, 1,
}


//= Structure
MapData :: struct {
	provinceImage : raylib.Image,
	terrainImage  : raylib.Image,
	heightImage   : raylib.Image,

	chunks        : [dynamic]MapChunk,
	provinces     : map[raylib.Color]Province,
	provColors    : [dynamic]raylib.Color,

	height        : i32,
	width         : i32,

	mapsettings   : ^MapSettingsData,
}

MapChunk :: struct {
	transform : linalg.Matrix4x4f32,

	mesh    : raylib.Mesh,
	mat     : raylib.Material,
	texture : raylib.Texture,
}

Point :: struct {
	idNext : int,
	pos    :  raylib.Vector3,
}


//= Enumerations
Direction :: enum {
	right,
	downright,
	down,
	downleft,
	left,
	upleft,
	up,
	upright,
}