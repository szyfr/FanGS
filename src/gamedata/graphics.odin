package gamedata


//= Imports
import "vendor:raylib"


//= Structures
GraphicsData :: struct {
	box        : raylib.Texture,
	box_nPatch : raylib.NPatchInfo,

	font       : raylib.Font,
}