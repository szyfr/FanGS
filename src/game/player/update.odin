package player


//= Imports
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:time"

import "vendor:raylib"

import "../settings"
import "../../game"
import "../../game/provinces"
import "../../graphics/worldmap"
import "../../utilities/matrix_math"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
	update_player_camera()
	update_player_mouse()
//	update_mapmodes() //TODO
	update_date_controls()
	if raylib.IsKeyPressed(raylib.KeyboardKey.ESCAPE) {
		game.pauseMenu = !game.pauseMenu
	}
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

	//* Edge scrolling
	if settings.data.edgeScrolling {
		if raylib.GetMouseX() <= EDGE_DIS do data.target.x   += MOVE_SPD
		if raylib.GetMouseY() <= EDGE_DIS do data.target.z   += MOVE_SPD
		if raylib.GetMouseX() >= settings.data.windowWidth - EDGE_DIS  do data.target.x -= MOVE_SPD
		if raylib.GetMouseY() >= settings.data.windowHeight - EDGE_DIS do data.target.z -= MOVE_SPD
	}

	//* Edge contraints/looping
	if worldmap.data != nil {
		if data.target.z >  0                   do data.target.z =  0
		if data.target.z < -worldmap.data.mapHeight do data.target.z = -worldmap.data.mapHeight

		if worldmap.data.mapsettings.loopMap {
			if data.target.x >  0                  do data.target.x = -worldmap.data.mapWidth
			if data.target.x < -worldmap.data.mapWidth do data.target.x = 0
		} else {
			if data.target.x >  0                  do data.target.x = 0
			if data.target.x < -worldmap.data.mapWidth do data.target.x = -worldmap.data.mapWidth
		}
	}
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

//* Map interaction
update_player_mouse :: proc() {
	if raylib.IsMouseButtonPressed(.LEFT) && !game.mainMenu {

		//* Getting mouse position and testing GUI
		position := raylib.GetMousePosition()
		//TODO: Testing for clicks on windows

		//* Creating ray and collision info
		data.ray = raylib.GetMouseRay(position, data)
		collision : raylib.RayCollision = {}
		width, height := -worldmap.data.mapWidth/2, -worldmap.data.mapHeight/2
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
			width-worldmap.data.mapWidth, 0, height, 1,
		}
		transformRight : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			width+worldmap.data.mapWidth, 0, height, 1,
		}

		//* Casting ray
		collision = raylib.GetRayCollisionMesh(
			data.ray,
			worldmap.data.collisionMesh,
			transformCenter,
		)
		if !collision.hit {
			collision = raylib.GetRayCollisionMesh(
				data.ray,
				worldmap.data.collisionMesh,
				transformLeft,
			)
			if !collision.hit {
				collision = raylib.GetRayCollisionMesh(
					data.ray,
					worldmap.data.collisionMesh,
					transformRight,
				)
			}
		}

		//* Calculate PosX
		posX : i32
		if collision.point.x*25 > 0 do posX =  i32(worldmap.data.mapWidth*25) - i32(collision.point.x*25)
		else                        do posX = -i32(collision.point.x*25) % i32(worldmap.data.mapWidth*25)

		//* Grab color
		col := raylib.GetImageColor(
			worldmap.data.provinceImage,
			posX,
			-i32(collision.point.z*25),
		)

		//* Set selected province
		prov, res := &worldmap.data.provincesdata[col]
		if res {
			if prov.type == provinces.ProvinceType.impassable do return
			data.currentSelection = prov
		} else do data.currentSelection = nil
	}
}

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

//* Date keybindings
update_date_controls :: proc() {
	if settings.is_key_pressed("pause") do worldmap.data.timePause = !worldmap.data.timePause
	if settings.is_key_pressed("faster") {
		switch worldmap.data.timeSpeed {
			case 1: worldmap.data.timeSpeed = 0
			case 2: worldmap.data.timeSpeed = 1
			case 3: worldmap.data.timeSpeed = 2
			case 4: worldmap.data.timeSpeed = 3
		}
	}
	if settings.is_key_pressed("slower") {
		switch worldmap.data.timeSpeed {
			case 0: worldmap.data.timeSpeed = 1
			case 1: worldmap.data.timeSpeed = 2
			case 2: worldmap.data.timeSpeed = 3
			case 3: worldmap.data.timeSpeed = 4
		}
	}
}