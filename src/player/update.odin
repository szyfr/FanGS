package player


//= Imports
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:time"
import "vendor:raylib"

import "../gamedata"
import "../guinew"
import "../settings"
import "../utilities/matrix_math"


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

	mod := ((playerdata.zoom) / 5) / 100

	// Key Movement
	// TODO: check origin of each key
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["up"].key)) {
		playerdata.target.z   += MOVE_SPD * (mod+3)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["down"].key)) {
		playerdata.target.z   -= MOVE_SPD * (mod+3)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["left"].key)) {
		playerdata.target.x   += MOVE_SPD * (mod+3)
	}
	if raylib.IsKeyDown(raylib.KeyboardKey(settingsdata.keybindings["right"].key)) {
		playerdata.target.x   -= MOVE_SPD * (mod+3)
	}

	// Drag movement
	if raylib.IsMouseButtonDown(.MIDDLE) {
		mouseDelta: raylib.Vector2 = raylib.GetMouseDelta()

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

	//* Edge contraints/looping
	if worlddata != nil {
		if playerdata.target.z >  0                   do playerdata.target.z =  0
		if playerdata.target.z < -worlddata.mapHeight do playerdata.target.z = -worlddata.mapHeight

		if worlddata.mapsettings.loopMap {
			if playerdata.target.x >  0                  do playerdata.target.x = -worlddata.mapWidth
			if playerdata.target.x < -worlddata.mapWidth do playerdata.target.x = 0
		} else {
			if playerdata.target.x >  0                  do playerdata.target.x = 0
			if playerdata.target.x < -worlddata.mapWidth do playerdata.target.x = -worlddata.mapWidth
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
//TODO: Improve distance calculation to reduce lag on click
update_player_mouse :: proc() {
	if raylib.IsMouseButtonPressed(.LEFT) && !gamedata.titleScreen {

		//* Getting mouse position and testing GUI
		position := raylib.GetMousePosition()
		result   := guinew.test_bounds_all(position)
		if !result do return

		//* Creating ray and collision info
		gamedata.playerdata.ray = raylib.GetMouseRay(position, gamedata.playerdata)
		collision : raylib.RayCollision = {}
		width, height := -gamedata.worlddata.mapWidth/2, -gamedata.worlddata.mapHeight/2
		transformCenter : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			width, 0, height, 1,
		}
		transformLeft : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			width-gamedata.worlddata.mapWidth, 0, height, 1,
		}
		transformRight : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			width+gamedata.worlddata.mapWidth, 0, height, 1,
		}

		//* Casting ray
		collision = raylib.GetRayCollisionMesh(
			gamedata.playerdata.ray,
			gamedata.worlddata.collisionMesh,
			transformCenter,
		)
		if !collision.hit {
			collision = raylib.GetRayCollisionMesh(
				gamedata.playerdata.ray,
				gamedata.worlddata.collisionMesh,
				transformLeft,
			)
			if !collision.hit {
				collision = raylib.GetRayCollisionMesh(
					gamedata.playerdata.ray,
					gamedata.worlddata.collisionMesh,
					transformRight,
				)
			}
		}

		//* Calculate PosX
		posX : i32
		if collision.point.x*25 > 0 do posX =  i32(gamedata.worlddata.mapWidth*25) - i32(collision.point.x*25)
		else                        do posX = -i32(collision.point.x*25) % i32(gamedata.worlddata.mapWidth*25)

		//* Grab color
		col := raylib.GetImageColor(
			gamedata.worlddata.provinceImage,
			posX,
			-i32(collision.point.z*25),
		)

		//* Set selected province
		prov, res := &gamedata.worlddata.provincesdata[col]
		if res do gamedata.playerdata.currentSelection = prov
		else   do gamedata.playerdata.currentSelection = nil
	}
}

get_zoom_percentage :: proc() -> f32 {
	max  := ZOOM_MAX - ZOOM_MIN
	zoom := gamedata.playerdata.zoom - ZOOM_MIN

	return zoom / max
}