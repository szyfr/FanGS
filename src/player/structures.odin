package player


//= Imports
import "../raylib"


//= Constants
MOVE_SPD ::   0.05
ZOOM_MAX :: 120
ZOOM_MIN ::  40
EDGE_DIS ::  50


//= Structures
PlayerData :: struct {
	camera       : raylib.Camera3d,
	lastMousePos : raylib.Vector2,
}