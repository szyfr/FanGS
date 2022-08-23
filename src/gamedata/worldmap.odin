package gamedata


//= Imports
import "vendor:raylib"


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

	mesh    : raylib.Mesh,
	model   : raylib.Model,
	texture : raylib.Texture,
}

Point :: struct {
	point :  raylib.Vector3,
	next  : ^Point,
}