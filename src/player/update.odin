package player


//= Imports
import "../raylib"

import "../gamedata"
import "../settings"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
	update_player_camera()
}

//* Player movement
update_player_movement :: proc() {
	using gamedata

	// Key Movement
	// TODO: check origin of each key
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["up"].key)) {
		playerdata.target.z   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["down"].key)) {
		playerdata.target.z   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["left"].key)) {
		playerdata.target.x   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.is_key_down(raylib.Keyboard_Key(settingsdata.keybindings["right"].key)) {
		playerdata.target.x   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}

	// Drag movement
	if raylib.is_mouse_button_down(.MOUSE_BUTTON_MIDDLE) {
		mouseDelta: raylib.Vector2 = raylib.get_mouse_delta()

	//	mod := (((playerdata.zoom + 20)) / 10000)
		mod := ((playerdata.zoom) / 5) / 100

		playerdata.target.x += mouseDelta.x * mod
		playerdata.target.z += mouseDelta.y * mod
	}

	// Edge scrolling
	if settingsdata.edgeScrolling {
		if raylib.get_mouse_x() <= EDGE_DIS {
			playerdata.target.x   += MOVE_SPD
		}
		if raylib.get_mouse_x() >= settingsdata.windowWidth - EDGE_DIS {
			playerdata.target.x   -= MOVE_SPD
		}
		if raylib.get_mouse_y() <= EDGE_DIS {
			playerdata.target.z   += MOVE_SPD
		}
		if raylib.get_mouse_y() >= settingsdata.windowHeight - EDGE_DIS {
			playerdata.target.z   -= MOVE_SPD
		}
	}
}

//* Player camera
update_player_camera :: proc() {
	using gamedata

//	if raylib.is_key_down(raylib.Keyboard_Key.KEY_Q) {
//		
//	}
//	if raylib.is_key_down(raylib.Keyboard_Key.KEY_E) {
//		
//	}
//	if raylib.is_key_down(raylib.Keyboard_Key.KEY_M) {
//		playerdata.cameraSlope = {0, 1, -5}
//	}
//	if raylib.is_mouse_button_down(.MOUSE_BUTTON_RIGHT) {
//		mouseDelta: raylib.Vector2 = raylib.get_mouse_delta()
//	}

	// Zoom
	playerdata.zoom -= raylib.get_mouse_wheel_move() * 2
	if playerdata.zoom > ZOOM_MAX do playerdata.zoom = ZOOM_MAX;
	if playerdata.zoom < ZOOM_MIN do playerdata.zoom = ZOOM_MIN;

	if playerdata.cameraSlope.x != 0 do playerdata.position.x = playerdata.target.x + playerdata.zoom / playerdata.cameraSlope.x
	else                             do playerdata.position.x = playerdata.target.x
	if playerdata.cameraSlope.y != 0 do playerdata.position.y = playerdata.target.y + playerdata.zoom / playerdata.cameraSlope.y
	else                             do playerdata.position.y = playerdata.target.y
	if playerdata.cameraSlope.z != 0 do playerdata.position.z = playerdata.target.z + playerdata.zoom / playerdata.cameraSlope.z
	else                             do playerdata.position.z = playerdata.target.z

//	playerdata.position.x = playerdata.target.x + playerdata.zoom / playerdata.cameraSlope.x
//	playerdata.position.y = playerdata.target.y + playerdata.zoom / playerdata.cameraSlope.y
//	playerdata.position.z = playerdata.target.z + playerdata.zoom / playerdata.cameraSlope.z
}