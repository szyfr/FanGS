package gamedata


//= Imports
import "../raylib"


//= Structures
PlayerData :: struct {
	using camera : raylib.Camera3d,
	zoom         : f32,
	cameraSlope  : raylib.Vector3,
	lastMousePos : raylib.Vector2,
}