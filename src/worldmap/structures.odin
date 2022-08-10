package worldmap


//= Imports
import "../raylib"


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

// TODO: Move to own file
Province :: struct {
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

Population :: struct {
	//etc
}

ProvinceModifier :: struct {
	//etc
}


//= Enumerations
Terrain :: enum {
	NULL,
	plains,
	swamp,
	dwarf_tunnel,
	dwarf_hold,
	cave,
}
ProvinceType :: enum {
	NULL,
	base,
    controllable,
    water,
    impassable,
}