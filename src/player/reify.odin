package player


//= Imports
import "../raylib"


//= Procedures

init :: proc() -> ^PlayerData {
	player := new(PlayerData)

	player.camera.position   = raylib.Vector3{  0,  5, -1}
	player.camera.target     = raylib.Vector3{  0,  0,  0}
	player.camera.up         = raylib.Vector3{  0,  1,  0}
	player.camera.fovy       = 60
	player.camera.projection = .CAMERA_PERSPECTIVE

	return player
}
free_data :: proc(player : ^PlayerData) {
	free(player)
}