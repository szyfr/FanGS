package gamedata


//= Imports
import "core:math/linalg"

import "vendor:raylib"


//= Constants

//= Structures
WorldData :: struct {
	provinceImage  : raylib.Image,
	terrainImage   : raylib.Image,

	collisionMesh  : raylib.Mesh,

	mapHeight      : f32,
	mapWidth       : f32,

	provincesdata  : map[raylib.Color]ProvinceData,
	provincescolor : [dynamic]raylib.Color,

	nationsdata    : [dynamic]NationData,

	provincePixelCount : int,

	mapsettings    : ^MapSettingsData,

	date      : Date,
	timeSpeed : uint,
	timeDelay : uint,
	timePause : bool,
}

Date :: struct {
	year  : uint,
	month : uint,
	day   : uint,
}

Point :: struct {
	idNext : int,
	pos    : raylib.Vector3,
	off    : raylib.Vector3,
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