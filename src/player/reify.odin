package player


//= Imports
import "../raylib"

import "../gamedata"


//= Constants
MOVE_SPD ::   0.05
ZOOM_MAX :: 120
ZOOM_MIN ::  40
EDGE_DIS ::  50


//= Procedures

init :: proc() {
	using gamedata

	playerdata = new(gamedata.PlayerData)

	playerdata.position   = raylib.Vector3{  0,  5, -1}
	playerdata.target     = raylib.Vector3{  0,  0,  0}
	playerdata.up         = raylib.Vector3{  0,  1,  0}
	playerdata.fovy       = 60
	playerdata.projection = .CAMERA_PERSPECTIVE
}
free_data :: proc() {
	free(gamedata.playerdata)
}