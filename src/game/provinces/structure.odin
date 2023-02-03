package provinces


//= Imports
import "vendor:raylib"

import "../population"
import "../nations"

//= Structures
ProvinceData :: struct {
	//* Map data
	//TODO Figure out how i want to do this
	nametx      : raylib.Texture,
	centerpoint : raylib.Vector3,

	//* Data
	localID : u32,
	color   : raylib.Color,
	shaderIndex: int,

	terrain : ^Terrain,
	type    : ProvinceType,

	maxInfrastructure : i16,
	curInfrastructure : i16,

	popList   : [dynamic]population.Population,
	avePop    : population.Population,

	buildings : [8]u8,

	modifierList : [dynamic]ProvinceModifier,

	owner : ^nations.Nation,
}

ProvinceModifier :: struct {
	//etc
}

Terrain :: struct {
	name  : ^cstring,
	color : raylib.Color,
}
ProvinceType :: enum {
	NULL,
	base,
    controllable,
    ocean,
	lake,
    impassable,
}