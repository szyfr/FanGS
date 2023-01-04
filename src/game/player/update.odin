package player


//= Imports
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:time"
import "vendor:raylib"

import "../settings"
import "../../utilities/matrix_math"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
	update_player_camera()
//	update_player_mouse() //TODO
//	update_mapmodes() //TODO
//	update_date_controls() //TODO
	//if raylib.IsKeyPressed(raylib.KeyboardKey.ESCAPE) && !gamedata.titleScreen do gamedata.pausemenu = !gamedata.pausemenu //TODO
}

//* Player movement
update_player_movement :: proc() {

	mod := ((data.zoom) / 5) / 100

	//* Key Movement
	if settings.is_key_down("up")    do data.target.z   += MOVE_SPD * (mod+3)
	if settings.is_key_down("down")  do data.target.z   -= MOVE_SPD * (mod+3)
	if settings.is_key_down("left")  do data.target.x   += MOVE_SPD * (mod+3)
	if settings.is_key_down("right") do data.target.x   -= MOVE_SPD * (mod+3)

	//* Drag movement
	if settings.is_key_down("grabmap") {
		mouseDelta: raylib.Vector2 = raylib.GetMouseDelta()

		data.target.x += mouseDelta.x * mod
		data.target.z += mouseDelta.y * mod
	}

//	//* Edge scrolling //TODO
//	if settings.data.edgeScrolling {
//		if GetMouseX() <= EDGE_DIS do playerdata.target.x   += MOVE_SPD
//		if GetMouseY() <= EDGE_DIS do playerdata.target.z   += MOVE_SPD
//		if GetMouseX() >= settings.data.windowWidth - EDGE_DIS  do playerdata.target.x   -= MOVE_SPD
//		if GetMouseY() >= settings.data.windowHeight - EDGE_DIS do playerdata.target.z   -= MOVE_SPD
//	}

//	//* Edge contraints/looping //TODO
//	if worlddata != nil {
//		if playerdata.target.z >  0                   do playerdata.target.z =  0
//		if playerdata.target.z < -worlddata.mapHeight do playerdata.target.z = -worlddata.mapHeight
//
//		if worlddata.mapsettings.loopMap {
//			if playerdata.target.x >  0                  do playerdata.target.x = -worlddata.mapWidth
//			if playerdata.target.x < -worlddata.mapWidth do playerdata.target.x = 0
//		} else {
//			if playerdata.target.x >  0                  do playerdata.target.x = 0
//			if playerdata.target.x < -worlddata.mapWidth do playerdata.target.x = -worlddata.mapWidth
//		}
//	}
}

//* Player camera
update_player_camera :: proc() {

	//* Zoom
	if      settings.is_key_pressed("zoompos") do data.zoom -= 2
	else if settings.is_key_pressed("zoomneg") do data.zoom += 2
	
	if data.zoom > ZOOM_MAX do data.zoom = ZOOM_MAX;
	if data.zoom < ZOOM_MIN do data.zoom = ZOOM_MIN;

	if data.cameraSlope.x != 0 do data.position.x = data.target.x + data.zoom / data.cameraSlope.x
	else                       do data.position.x = data.target.x
	if data.cameraSlope.y != 0 do data.position.y = data.target.y + data.zoom / data.cameraSlope.y
	else                       do data.position.y = data.target.y
	if data.cameraSlope.z != 0 do data.position.z = data.target.z + data.zoom / data.cameraSlope.z
	else                       do data.position.z = data.target.z
	
}

////* Map interaction //TODO
//update_player_mouse :: proc() {
//	if raylib.IsMouseButtonPressed(.LEFT) && !gamedata.titleScreen {
//
//		//* Getting mouse position and testing GUI
//		position := raylib.GetMousePosition()
//		result   := guinew.test_bounds_all(position)
//		if !result do return
//
//		//* Creating ray and collision info
//		gamedata.playerdata.ray = raylib.GetMouseRay(position, gamedata.playerdata)
//		collision : raylib.RayCollision = {}
//		width, height := -gamedata.worlddata.mapWidth/2, -gamedata.worlddata.mapHeight/2
//		transformCenter : linalg.Matrix4x4f32 = {
//			-1, 0,  0, 0,
//			 0, 1,  0, 0,
//			 0, 0, -1, 0,
//			width, 0, height, 1,
//		}
//		transformLeft : linalg.Matrix4x4f32 = {
//			-1, 0,  0, 0,
//			 0, 1,  0, 0,
//			 0, 0, -1, 0,
//			width-gamedata.worlddata.mapWidth, 0, height, 1,
//		}
//		transformRight : linalg.Matrix4x4f32 = {
//			-1, 0,  0, 0,
//			 0, 1,  0, 0,
//			 0, 0, -1, 0,
//			width+gamedata.worlddata.mapWidth, 0, height, 1,
//		}
//
//		//* Casting ray
//		collision = raylib.GetRayCollisionMesh(
//			gamedata.playerdata.ray,
//			gamedata.worlddata.collisionMesh,
//			transformCenter,
//		)
//		if !collision.hit {
//			collision = raylib.GetRayCollisionMesh(
//				gamedata.playerdata.ray,
//				gamedata.worlddata.collisionMesh,
//				transformLeft,
//			)
//			if !collision.hit {
//				collision = raylib.GetRayCollisionMesh(
//					gamedata.playerdata.ray,
//					gamedata.worlddata.collisionMesh,
//					transformRight,
//				)
//			}
//		}
//
//		//* Calculate PosX
//		posX : i32
//		if collision.point.x*25 > 0 do posX =  i32(gamedata.worlddata.mapWidth*25) - i32(collision.point.x*25)
//		else                        do posX = -i32(collision.point.x*25) % i32(gamedata.worlddata.mapWidth*25)
//
//		//* Grab color
//		col := raylib.GetImageColor(
//			gamedata.worlddata.provinceImage,
//			posX,
//			-i32(collision.point.z*25),
//		)
//
//		//* Set selected province
//		prov, res := &gamedata.worlddata.provincesdata[col]
//		if res {
//			if prov.provType == gamedata.ProvinceType.impassable do return
//			gamedata.playerdata.currentSelection = prov
//		} else do gamedata.playerdata.currentSelection = nil
//	}
//}
//
////* Mapmode keybindings //TODO
//update_mapmodes :: proc() {
//	using raylib, settings, gamedata
//
//	if is_key_pressed("over")     do playerdata.curMapmode = .overworld
//	if is_key_pressed("politic")  do playerdata.curMapmode = .political
//	if is_key_pressed("terrain")  do playerdata.curMapmode = .terrain
//	if is_key_pressed("control")  do playerdata.curMapmode = .control
//	if is_key_pressed("pop")      do playerdata.curMapmode = .population
//	if is_key_pressed("ancestry") do playerdata.curMapmode = .ancestry
//	if is_key_pressed("culture")  do playerdata.curMapmode = .culture
//	if is_key_pressed("religion") do playerdata.curMapmode = .religion
//}
//
////* Date keybindings //TODO
//update_date_controls :: proc() {
//	using raylib, settings, gamedata
//
//	if is_key_pressed("pause") {
//		if worlddata.timePause do worlddata.timePause = false
//		else                   do worlddata.timePause = true
//	}
//	if is_key_pressed("faster") {
//		switch worlddata.timeSpeed {
//			case 1: worlddata.timeSpeed = 0
//			case 2: worlddata.timeSpeed = 1
//			case 3: worlddata.timeSpeed = 2
//			case 4: worlddata.timeSpeed = 3
//		}
//	}
//	if is_key_pressed("slower") {
//		switch worlddata.timeSpeed {
//			case 0: worlddata.timeSpeed = 1
//			case 1: worlddata.timeSpeed = 2
//			case 2: worlddata.timeSpeed = 3
//			case 3: worlddata.timeSpeed = 4
//		}
//	}
//}