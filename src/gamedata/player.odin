package gamedata


//= Imports
import "vendor:raylib"


//= Constants
MOVE_SPD : f32 :   0.05
ZOOM_MAX : f32 :  40
ZOOM_MIN : f32 :   5
EDGE_DIS : i32 :  50


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
	population,
	ancestry,
	culture,
	religion,
}