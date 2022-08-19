package player


//= Imports
import "../raylib"

import "../gamedata"
import "../settings"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
}

//* Player controls
update_player_movement :: proc() {
	using gamedata

	// Key Movement
	// TODO: check origin of each key
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["up"].key)) {
		playerdata.position.z += MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
		playerdata.target.z   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["down"].key)) {
		playerdata.position.z -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
		playerdata.target.z   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["left"].key)) {
		playerdata.position.x += MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
		playerdata.target.x   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["right"].key)) {
		playerdata.position.x -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
		playerdata.target.x   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX);
	}

	// Drag movement
	if raylib.is_mouse_button_down(.MOUSE_BUTTON_RIGHT) {
		mouseDelta: raylib.Vector2 = raylib.get_mouse_delta();

		mod := (((playerdata.fovy + 20)) / 10000)

		playerdata.position.x += mouseDelta.x * mod;
		playerdata.position.z += mouseDelta.y * mod;
		playerdata.target.x += mouseDelta.x   * mod;
		playerdata.target.z += mouseDelta.y   * mod;
	}

	// Edge scrolling
	if settingsdata.edgeScrolling {
		if raylib.get_mouse_x() <= EDGE_DIS {
			playerdata.position.x += MOVE_SPD;
			playerdata.target.x   += MOVE_SPD;
		}
		if raylib.get_mouse_x() >= settingsdata.windowWidth - EDGE_DIS {
			playerdata.position.x -= MOVE_SPD;
			playerdata.target.x   -= MOVE_SPD;
		}
		if raylib.get_mouse_y() <= EDGE_DIS {
			playerdata.position.z += MOVE_SPD;
			playerdata.target.z   += MOVE_SPD;
		}
		if raylib.get_mouse_y() >= settingsdata.windowHeight - EDGE_DIS {
			playerdata.position.z -= MOVE_SPD;
			playerdata.target.z   -= MOVE_SPD;
		}
	}


	// Zoom
	playerdata.fovy -= raylib.get_mouse_wheel_move()*4;

	if playerdata.fovy > ZOOM_MAX do playerdata.fovy = ZOOM_MAX;
	if playerdata.fovy < ZOOM_MIN do playerdata.fovy = ZOOM_MIN;
}