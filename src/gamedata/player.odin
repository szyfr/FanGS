package gamedata


//= Imports
import "vendor:raylib"


//= Structures
PlayerData :: struct {
	using camera : raylib.Camera3D,
	zoom         : f32,
	cameraSlope  : raylib.Vector3,
	lastMousePos : raylib.Vector2,

	ray              :  raylib.Ray,
	currentSelection : ^ProvinceData,

	curMapmode : Mapmode,
}


//= Enumerations
Mapmode :: enum {
	overworld,
	political,
	terrain,
	control,
}