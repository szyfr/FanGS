package main



//= Imports
import "raylib"

//= Constants
MOVE_SPD ::   0.05
ZOOM_MAX :: 100
ZOOM_MIN ::  40


//= Global Variables
player: ^Player;


//= Structures
Player :: struct {
	camera: raylib.Camera3d,
}


//= Enumerations

//= Procedures

init_player :: proc() {
	player = new(Player);

	player.camera.position   = raylib.Vector3{  0,  5, -1};
	player.camera.target     = raylib.Vector3{  0,  0,  0};
	player.camera.up         = raylib.Vector3{  0,  1,  0};
	player.camera.fovy       = 60;
	player.camera.projection = .CAMERA_PERSPECTIVE;
}

free_player :: proc() {
	free(player);
}


update_player_movement :: proc() {

	// Movement
	if raylib.is_key_down(.KEY_W) {
		player.camera.position.z += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.z   += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(.KEY_S) {
		player.camera.position.z -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.z   -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(.KEY_A) {
		player.camera.position.x += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.x   += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(.KEY_D) {
		player.camera.position.x -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.x   -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}


	// Zoom
	player.camera.fovy -= raylib.get_mouse_wheel_move();

	if player.camera.fovy > ZOOM_MAX do player.camera.fovy = ZOOM_MAX;
	if player.camera.fovy < ZOOM_MIN do player.camera.fovy = ZOOM_MIN;
}