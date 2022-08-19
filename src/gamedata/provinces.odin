package gamedata


//= Imports
import "../raylib"


//= Structure
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