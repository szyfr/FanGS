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

	provincePixelCount : int,

	mapsettings    : ^MapSettingsData,

	date      : Date,
	timeSpeed : uint,
	timeDelay : uint,
	timePause : bool,
}

ProvinceData :: struct {
	//* Image
	provmesh  : raylib.Mesh,
	provmodel : raylib.Model,

	provImage : raylib.Image,
	currenttx : raylib.Texture,

	position      : raylib.Vector3,
	centerpoint   : raylib.Vector3,
	height, width : f32,

	//* Data
	localID  : u32,
	color    : raylib.Color,

	terrain  : Terrain,
	provType : ProvinceType,

	maxInfrastructure : i16,
	curInfrastructure : i16,

	popList   : [dynamic]Population,
	avePop    : Population,

	// TODO: make enum?
	buildings : [8]u8,

	modifierList : [dynamic]ProvinceModifier,
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