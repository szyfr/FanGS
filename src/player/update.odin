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
	if mapdata != nil {
		if playerdata.target.z > 0                   do playerdata.target.z = 0
		if playerdata.target.z < f32(mapdata.height) do playerdata.target.z = f32(mapdata.height)

		if mapdata.mapsettings.loopMap {
			if playerdata.target.x > 0                  do playerdata.target.x = f32(mapdata.width)
			if playerdata.target.x < f32(mapdata.width) do playerdata.target.x = 0
		} else {
			if playerdata.target.x > 0                  do playerdata.target.x = 0
			if playerdata.target.x < f32(mapdata.width) do playerdata.target.x = f32(mapdata.width)
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

		//* Casting ray
		width := gamedata.mapdata.provinceImage.width/250
		for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
			//* Calculate distance to each chunk
			distX := math.pow(gamedata.mapdata.chunks[i].transform[3,0] - gamedata.playerdata.target.x, 2)
			distZ := math.pow(gamedata.mapdata.chunks[i].transform[3,2] - gamedata.playerdata.target.z, 2)
			distance := math.sqrt(distX + distZ)

			//* If chunk is within range, cast ray
			if distance <= 35 * (get_zoom_percentage()+1) {
				collision = raylib.GetRayCollisionMesh(
					gamedata.playerdata.ray,
					gamedata.mapdata.chunks[i].mesh,
					gamedata.mapdata.chunks[i].transform,
				)
			}
			if collision.hit do break

			//* Checking left loop edges
			if gamedata.playerdata.target.x <= -f32((width-4) * 10) {
				mod : linalg.Matrix4x4f32 = {
					             1, 0, 0, 0,
					             0, 1, 0, 0,
					             0, 0, 1, 0,
					-f32(width*10), 0, 0, 1,
				}
				collision = raylib.GetRayCollisionMesh(
					gamedata.playerdata.ray,
					gamedata.mapdata.chunks[i].mesh,
					matrix_math.mat_mult(gamedata.mapdata.chunks[i].transform, mod),
				)
			}
			if collision.hit do break

			//* Checking right loop edges
			if gamedata.playerdata.target.x >= -40 {
				mod : linalg.Matrix4x4f32 = {
					            1, 0, 0, 0,
					            0, 1, 0, 0,
					            0, 0, 1, 0,
					f32(width*10), 0, 0, 1,
				}
				collision = raylib.GetRayCollisionMesh(
					gamedata.playerdata.ray,
					gamedata.mapdata.chunks[i].mesh,
					matrix_math.mat_mult(gamedata.mapdata.chunks[i].transform, mod),
				)
			}
			if collision.hit do break
		}

		if collision.hit {
			//* Calculate x position
			posX : i32
			if collision.point.x*25 > 0 do posX =  gamedata.mapdata.provinceImage.width - i32(collision.point.x*25)
			else                        do posX = -i32(collision.point.x*25)%gamedata.mapdata.provinceImage.width
			
			//* Grab color
			col := raylib.GetImageColor(
				gamedata.mapdata.provinceImage,
				posX,
				-i32(collision.point.z*25),
			)

			//* Set selected province
			prov, res := &gamedata.mapdata.provinces[col]
			if res do gamedata.playerdata.currentSelection = prov
			else   do gamedata.playerdata.currentSelection = nil
		} else do gamedata.playerdata.currentSelection = nil
	}
}

get_zoom_percentage :: proc() -> f32 {
	max  := ZOOM_MAX - ZOOM_MIN
	zoom := gamedata.playerdata.zoom - ZOOM_MIN

	return zoom / max
}