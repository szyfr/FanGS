package player


//= Imports
import "vendor:raylib"

import "../gamedata"


//= Constants
MOVE_SPD : f32 :   0.05
ZOOM_MAX : f32 :  40
ZOOM_MIN : f32 :   5
EDGE_DIS : i32 :  50


//= Procedures

init :: proc() {
	using gamedata

	playerdata = new(gamedata.PlayerData)

	playerdata.position    = {0, 5, -1}
	playerdata.target      = {0, 0,  0}
	playerdata.up          = {0, 1,  0}
	playerdata.fovy        = 60
	playerdata.projection  = .PERSPECTIVE

	playerdata.zoom        = 5
	playerdata.cameraSlope = {0, 1, -5}
}
free_data :: proc() {
	free(gamedata.playerdata)
}