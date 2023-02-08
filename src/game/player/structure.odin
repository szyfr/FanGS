package player


//= Imports
import "vendor:raylib"

import "../provinces"
import "../nations"
import "../../graphics/mapmodes"


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
	currentSelection : ^provinces.ProvinceData,
	nation           : ^nations.Nation,

	curMapmode       : mapmodes.Mapmode,
}