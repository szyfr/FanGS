package player


//= Imports
import "vendor:raylib"

import "../gamedata"
import "../settings"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
	update_player_camera()
	update_player_mouse()
}

//* Player movement
update_player_movement :: proc() {
	using gamedata

	// Key Movement
	// TODO: check origin of each key
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["up"].key)) {
		playerdata.target.z   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["down"].key)) {
		playerdata.target.z   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["left"].key)) {
		playerdata.target.x   += MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["right"].key)) {
		playerdata.target.x   -= MOVE_SPD * (playerdata.fovy / ZOOM_MAX)
	}

	// Drag movement
	if raylib.IsMouseButtonDown(.MIDDLE) {
		mouseDelta: raylib.Vector2 = raylib.GetMouseDelta()

		mod := ((playerdata.zoom) / 5) / 100

		playerdata.target.x += mouseDelta.x * mod
		playerdata.target.z += mouseDelta.y * mod
	}

	// Edge scrolling
	if settingsdata.edgeScrolling {
		if raylib.GetMouseX() <= EDGE_DIS {
			playerdata.target.x   += MOVE_SPD
		}
		if raylib.GetMouseX() >= settingsdata.windowWidth - EDGE_DIS {
			playerdata.target.x   -= MOVE_SPD
		}
		if raylib.GetMouseY() <= EDGE_DIS {
			playerdata.target.z   += MOVE_SPD
		}
		if raylib.GetMouseY() >= settingsdata.windowHeight - EDGE_DIS {
			playerdata.target.z   -= MOVE_SPD
		}
	}
}

//* Player camera
update_player_camera :: proc() {
	using gamedata

	// Zoom
	playerdata.zoom -= raylib.GetMouseWheelMove() * 2
	if playerdata.zoom > ZOOM_MAX do playerdata.zoom = ZOOM_MAX;
	if playerdata.zoom < ZOOM_MIN do playerdata.zoom = ZOOM_MIN;

	if playerdata.cameraSlope.x != 0 do playerdata.position.x = playerdata.target.x + playerdata.zoom / playerdata.cameraSlope.x
	else                             do playerdata.position.x = playerdata.target.x
	if playerdata.cameraSlope.y != 0 do playerdata.position.y = playerdata.target.y + playerdata.zoom / playerdata.cameraSlope.y
	else                             do playerdata.position.y = playerdata.target.y
	if playerdata.cameraSlope.z != 0 do playerdata.position.z = playerdata.target.z + playerdata.zoom / playerdata.cameraSlope.z
	else                             do playerdata.position.z = playerdata.target.z
}

//* Map interaction
update_player_mouse :: proc() {
	
}