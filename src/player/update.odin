package player


//= Imports
import "../raylib"

import "../settings"


//= Procedures

//* Logic update
update :: proc(
	player : ^PlayerData,
	settings : ^settings.SettingsData,
	) {
	
	update_player_movement(player, settings)
}

//* Player controls
update_player_movement :: proc(
	player : ^PlayerData,
	settings : ^settings.SettingsData,
	) {

	// Key Movement
	// TODO: check origin of each key
	if raylib.is_key_down(raylib.Keyboard_Key(settings.keybindings["up"].key)) {
		player.camera.position.z += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.z   += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settings.keybindings["down"].key)) {
		player.camera.position.z -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.z   -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settings.keybindings["left"].key)) {
		player.camera.position.x += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.x   += MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settings.keybindings["right"].key)) {
		player.camera.position.x -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
		player.camera.target.x   -= MOVE_SPD * (player.camera.fovy / ZOOM_MAX);
	}

	// Drag movement
	if raylib.is_mouse_button_down(.MOUSE_BUTTON_RIGHT) {
		mouseDelta: raylib.Vector2 = raylib.get_mouse_delta();

		player.camera.position.x += mouseDelta.x * 0.01;
		player.camera.position.z += mouseDelta.y * 0.01;

		player.camera.target.x += mouseDelta.x * 0.01;
		player.camera.target.z += mouseDelta.y * 0.01;
	}

	// Edge scrolling
	if settings.edgeScrolling {
		if raylib.get_mouse_x() <= EDGE_DIS {
			player.camera.position.x += MOVE_SPD;
			player.camera.target.x   += MOVE_SPD;
		}
		if raylib.get_mouse_x() >= settings.windowWidth - EDGE_DIS {
			player.camera.position.x -= MOVE_SPD;
			player.camera.target.x   -= MOVE_SPD;
		}
		if raylib.get_mouse_y() <= EDGE_DIS {
			player.camera.position.z += MOVE_SPD;
			player.camera.target.z   += MOVE_SPD;
		}
		if raylib.get_mouse_y() >= settings.windowHeight - EDGE_DIS {
			player.camera.position.z -= MOVE_SPD;
			player.camera.target.z   -= MOVE_SPD;
		}
	}


	// Zoom
	player.camera.fovy -= raylib.get_mouse_wheel_move();

	if player.camera.fovy > ZOOM_MAX do player.camera.fovy = ZOOM_MAX;
	if player.camera.fovy < ZOOM_MIN do player.camera.fovy = ZOOM_MIN;
}