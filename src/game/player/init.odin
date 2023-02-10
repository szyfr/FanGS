package player


//= Imports
import "vendor:raylib"

import "../../game"


//= Constants
MOVE_SPD : f32 :   0.05
ZOOM_MAX : f32 :  40
ZOOM_MIN : f32 :   2
EDGE_DIS : i32 :  50


//= Procedures

//* Initialization
init :: proc() {

	game.player = new(game.Player)

	game.player.position    = {0, 5, -1}
	game.player.target      = {0, 0,  0}
	game.player.up          = {0, 1,  0}
	game.player.fovy        = 60
	game.player.projection  = .PERSPECTIVE

	game.player.zoom        = 5
	game.player.cameraSlope = {0, 1, -5}
}

//* Close
close :: proc() {
	free(game.player)
}