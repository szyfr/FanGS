package game


//= Imports
import "vendor:raylib"


//= Global
state : Gamestate = .mainmenu
menu  : Menu      = .none
abort : bool      =  false


//* Graphics data
general_textbox			: raylib.Texture2D
general_textbox_small	: raylib.Texture2D
general_textbox_npatch	: raylib.NPatchInfo

font : raylib.Font


//* Data Storage
settings		: ^Settings
player			: ^Player
localization	:  map[string]cstring
mods			:  [dynamic]cstring
modsDirectory	:  [dynamic]cstring

//* Map data
worldmap	: ^Worldmap
provinces	:  map[raylib.Color]Province
nations		:  map[string]Nation
ancestries	:  map[string]Ancestry
cultures	:  map[string]Culture
religions	:  map[string]Religion
terrains	:  map[string]Terrain


//= Enumerations
Gamestate :: enum {
	mainmenu,
	choose,
	play,
	observer,
}
Menu :: enum {
	none,
	pause,
	options,
	mods,
}