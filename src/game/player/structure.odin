package player


//= Imports
import "vendor:raylib"


//= Globals
//TODO Might want to move this to a "game" package
data : ^PlayerData


//= Structures
PlayerData :: struct {
	using camera     : raylib.Camera3D,
	zoom             : f32,
	cameraSlope      : raylib.Vector3,
	lastMousePos     : raylib.Vector2,

	ray              :  raylib.Ray,
//	currentSelection : ^ProvinceData,

	curMapmode       : Mapmode,
}


//= Enumerations
//TODO
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