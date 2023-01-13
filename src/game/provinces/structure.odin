package provinces


//= Imports
import "vendor:raylib"


//= Structures
ProvinceData :: struct {
	//* Image
	provmesh  : raylib.Mesh,
	provmodel : raylib.Model,

	provImage : raylib.Image,
	currenttx : raylib.Texture,
	nametx    : raylib.Texture,

	position      : raylib.Vector3,
	centerpoint   : raylib.Vector3,
	height, width : f32,

	//* Data
	localID : u32,
	color   : raylib.Color,

	terrain : Terrain,
	type    : ProvinceType,

	maxInfrastructure : i16,
	curInfrastructure : i16,

//	popList   : [dynamic]Population,
//	avePop    : Population,

	buildings : [8]u8,

	modifierList : [dynamic]ProvinceModifier,

//	owner : ^NationData,
}

ProvinceModifier :: struct {
	//etc
}


//= Enumerations
Terrain :: enum {
	NULL,
	grassland,
	swamp,
	deep_road,
	dwarf_hold,
	goblin_hold,
	kobold_hold,
	orc_hold,
	drow_hold,
	cave,
}
ProvinceType :: enum {
	NULL,
	base,
    controllable,
    ocean,
	lake,
    impassable,
}