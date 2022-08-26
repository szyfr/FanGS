package player


//= Imports
import "core:fmt"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "vendor:raylib"

import "../gamedata"
import "../guinew"
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
	if raylib.IsMouseButtonPressed(.LEFT) {
		position := raylib.GetMousePosition()
		result   := guinew.test_bounds_all(position)
		if !result do return

		//TODO: Cast a ray to models then get color
		gamedata.playerdata.ray = raylib.GetMouseRay(position, gamedata.playerdata)
		collision : raylib.RayCollision = {}

		for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
			pos : raylib.Vector3 = gamedata.mapdata.chunks[i]
		//	fmt.printf("%v,%v,%v\n",pos.x,pos.y,pos.z)

			cosres := linalg.cos(f32(linalg.PI))
			sinres := linalg.sin(f32(linalg.PI))
			transform : linalg.Matrix4x4f32 = {
				  cosres, 0, 0*-sinres, -pos.x,
				       0, 5,         0, pos.y,
				0*sinres, 0,    cosres, -pos.z,
				       0, 0,         0,     1,
			}

		//	rotation : linalg.Matrix4x4f32 = {
		//		cosres, 0, -sinres, 0,
		//		     0, 1,       0, 0,
		//		sinres, 0,  cosres, 0,
		//		     0, 0,       0, 1,
		//	}
		//	transform : linalg.Matrix4x4f32 = {
		//		10.046, 0,  0    , pos.x,
		//		 0    , 5,  0    , pos.y,
		//		 0    , 0, 10.046, pos.z,
		//		 0    , 0,  0    ,     1,
		//	}
			collision = raylib.GetRayCollisionMesh(
				gamedata.playerdata.ray,
				gamedata.mapdata.chunks[i].mesh,
				transform,
			)
			if collision.hit do fmt.printf("%v,%v,%v,%v\n%v,%v,%v,%v\n%v,%v,%v,%v\n%v,%v,%v,%v\n\n",
				transform[0,0],transform[0,1],transform[0,2],transform[0,3],
				transform[1,0],transform[1,1],transform[1,2],transform[1,3],
				transform[2,0],transform[2,1],transform[2,2],transform[2,3],
				transform[3,0],transform[3,1],transform[3,2],transform[3,3],
			)
			if collision.hit do break
		}

		if collision.hit do fmt.printf("%v,%v,%v\n",collision.point.x,collision.point.y,collision.point.z)
	}
}