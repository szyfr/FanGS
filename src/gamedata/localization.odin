package gamedata


//= Structures
LocalizationData :: struct {
	// Main menu
	newGame  : cstring,
	loadGame : cstring,
	mods     : cstring,
	options  : cstring,
	quit     : cstring,
	title    : cstring,

	missing  : cstring,

	provTypes : [5]cstring,

	//* Mod
	worldLocalization : [dynamic]cstring,

	baseLocalIndex      : [dynamic]u32,
	baseLocalArray      : [dynamic]cstring,
	terrainLocalIndex   : [dynamic]u32,
	terrainLocalArray   : [dynamic]cstring,
	provincesLocalIndex : [dynamic]u32,
	provincesLocalArray : [dynamic]cstring,
	nationsLocalIndex   : [dynamic]u32,
	nationsLocalArray   : [dynamic]cstring,
}