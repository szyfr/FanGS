package player


//= Imports
import "vendor:raylib"

import "../gamedata"


//= Procedures

//* Initialize
init :: proc() {
	using gamedata

	//* Init player data
	playerdata = new(gamedata.PlayerData)

	playerdata.position    = {0, 5, -1}
	playerdata.target      = {0, 0,  0}
	playerdata.up          = {0, 1,  0}
	playerdata.fovy        = 60
	playerdata.projection  = .PERSPECTIVE

	playerdata.zoom        = 5
	playerdata.cameraSlope = {0, 1, -5}
}

//* Free
free_data :: proc() {
	free(gamedata.playerdata)
}