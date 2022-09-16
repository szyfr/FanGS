package gamedata


//= Imports
import "core:math/linalg"

import "vendor:raylib"


//= Constants

//= Structures
WorldData :: struct {
	provinceImage  : raylib.Image,
	terrainImage   : raylib.Image,

	provincesdata  : map[raylib.Color]ProvinceData,
	provincescolor : [dynamic]raylib.Color,

	provincePixelCount : int,

	mapsettings    : ^MapSettingsData,
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

	// TODO: make enum?
	buildings : [8]u8,

	modifierList : [dynamic]ProvinceModifier,
}