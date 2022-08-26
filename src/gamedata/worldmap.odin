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
}

MapChunk :: struct {
	using location : raylib.Vector3,
	transform : linalg.Matrix4x4f32,

	mesh    : raylib.Mesh,
	model   : raylib.Model,
	mat     : raylib.Material,
	texture : raylib.Texture,
}

Point :: struct {
	point :  raylib.Vector3,
	next  : ^Point,
}