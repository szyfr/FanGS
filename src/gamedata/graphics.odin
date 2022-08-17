package gamedata


//= Imports
import "../raylib"


//= Structures
GraphicsData :: struct {
	box        : raylib.Texture,
	box_nPatch : raylib.N_Patch_Info,

	font       : raylib.Font,
}