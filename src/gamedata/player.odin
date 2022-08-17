package gamedata


//= Imports
import "../raylib"


//= Structures
PlayerData :: struct {
	using camera : raylib.Camera3d,
	lastMousePos : raylib.Vector2,
}