package player


//= Imports
import "vendor:raylib"


//= Constants
MOVE_SPD : f32 :   0.05
ZOOM_MAX : f32 :  40
ZOOM_MIN : f32 :   2
EDGE_DIS : i32 :  50


//= Procedures

//* Initialization
init :: proc() {

	data = new(PlayerData)

	data.position    = {0, 5, -1}
	data.target      = {0, 0,  0}
	data.up          = {0, 1,  0}
	data.fovy        = 60
	data.projection  = .PERSPECTIVE

	data.zoom        = 5
	data.cameraSlope = {0, 1, -5}

}

//* Close
close :: proc() {
	free(data)
}