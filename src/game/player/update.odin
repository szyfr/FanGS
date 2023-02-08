package player


//= Imports
import "core:fmt"
import "core:math"
import "core:math/linalg"
import "core:math/linalg/glsl"
import "core:strings"
import "core:time"

import "vendor:raylib"

import "../settings"
import "../../game"
import "../../game/provinces"
import "../../graphics/worldmap"
import "../../graphics/mapmodes"
import "../../utilities/matrix_math"


//= Procedures

//* Logic update
update :: proc() {
	update_player_movement()
	update_player_camera()
	update_player_mouse()
	update_mapmodes()
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
	if raylib.IsMouseButtonPressed(.LEFT) && game.state != .mainmenu {

		//* Getting mouse position and testing GUI
		position := raylib.GetMousePosition()
		//TODO: Testing for clicks on windows
		#partial switch game.state {
			case .choose:
				//* Check nation viewer
				elementWidth  : f32 = f32(settings.data.windowWidth) / 4
				elementHeight : f32 = f32(settings.data.windowHeight)
				topright      : f32 = f32(settings.data.windowWidth) - elementWidth
				botleft       : f32 = f32(settings.data.windowHeight) - 50
				res := is_within(
					position,
					{ topright, 0, elementWidth, elementHeight },
				)
				if !res do return

				//* Check play button
				res = is_within(
					position,
					{ 25, botleft - 25, 200, 50 },
				)
				if !res do return
			case .play, .observer:
		}

		//* Creating ray and collision info
		data.ray = raylib.GetMouseRay(position, data)
		collision : raylib.RayCollision = {}
		width, height := -worldmap.data.mapWidth/2, -worldmap.data.mapHeight/2
		transformCenter : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			 0, 0,  0, 1,
		}
		transformLeft : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			-worldmap.data.mapWidth, 0, 0, 1,
		}
		transformRight : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			+worldmap.data.mapWidth, 0, 0, 1,
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
		if collision.point.x*20 > 0 do posX =  i32(worldmap.data.mapWidth*20) - i32(collision.point.x*20)
		else                        do posX = -i32(collision.point.x*20) % i32(worldmap.data.mapWidth*20)

		//* Grab color
		col := raylib.GetImageColor(
			worldmap.data.provinceImage,
			posX,
			-i32(collision.point.z*20),
		)

		//* Set selected province
		prov, res := &worldmap.data.provincesdata[col]
		if res && prov.type != provinces.ProvinceType.impassable {
			data.currentSelection = prov
			shaderVariable := [4]f32{
				f32(col.r) / 255,
				f32(col.g) / 255,
				f32(col.b) / 255,
				f32(col.a) / 255,
			}
			worldmap.change_shader_variable("chosenProv", shaderVariable)
		} else {
			data.currentSelection = nil
			shaderVariable := [4]f32{ 255, 255, 255, 255 }
			worldmap.change_shader_variable("chosenProv", shaderVariable)
		}
	}
}

//* Mapmode keybindings
update_mapmodes :: proc() {
	//* Check input
	res, mapmode := settings.is_mapmode_pressed()

	if res {
		#partial switch mapmode {
			case .overworld:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{
						f32(worldmap.data.provincesdata[p].color.r)/255,
						f32(worldmap.data.provincesdata[p].color.g)/255,
						f32(worldmap.data.provincesdata[p].color.b)/255,
						f32(worldmap.data.provincesdata[p].color.a)/255,
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .political:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }

					if worldmap.data.provincesdata[p].owner != nil {
						shaderVariable = [4]f32{
							f32(worldmap.data.provincesdata[p].owner.color.r)/255,
							f32(worldmap.data.provincesdata[p].owner.color.g)/255,
							f32(worldmap.data.provincesdata[p].owner.color.b)/255,
							f32(worldmap.data.provincesdata[p].owner.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .terrain:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{
						f32(worldmap.data.provincesdata[p].terrain.color.r)/255,
						f32(worldmap.data.provincesdata[p].terrain.color.g)/255,
						f32(worldmap.data.provincesdata[p].terrain.color.b)/255,
						f32(worldmap.data.provincesdata[p].terrain.color.a)/255,
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .control:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable : [4]f32
					#partial switch worldmap.data.provincesdata[p].type {
						case .base:
							shaderVariable = [4]f32{ 0.75, 0.75, 0.75, 1 }
							break
						case .controllable:
							shaderVariable = [4]f32{ 0.50, 0.50, 0.50, 1 }
							break
						case .ocean:
							shaderVariable = [4]f32{ 0.50, 0.50, 1.00, 1 }
							break
						case .lake:
							shaderVariable = [4]f32{ 0.25, 0.25, 1.00, 1 }
							break
						case .impassable:
							shaderVariable = [4]f32{ 0.00, 0.00, 0.00, 1 }
							break
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .population:
				builder : strings.Builder
				maxPopulation : u64 = 0 
				for p in worldmap.data.provincesdata {
					count := worldmap.data.provincesdata[p].avePop.count
					if maxPopulation < count do maxPopulation = count
					fmt.printf("",count)
				}
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }
					if maxPopulation > 0 && worldmap.data.provincesdata[p].type != .impassable {
						populationRatio : f32 = f32(worldmap.data.provincesdata[p].avePop.count) / f32(maxPopulation)
						shaderVariable = [4]f32{
							1 - populationRatio,
							populationRatio,
							0, 1,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .infrastructure:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					infraRatio     := f32(worldmap.data.provincesdata[p].curInfrastructure) / f32(worldmap.data.provincesdata[p].maxInfrastructure)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }
					if worldmap.data.provincesdata[p].type != .impassable {
						shaderVariable = [4]f32{
							1 - infraRatio,
							infraRatio,
							0, 1,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .ancestry:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if worldmap.data.provincesdata[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(worldmap.data.provincesdata[p].avePop.ancestry.color.r)/255,
							f32(worldmap.data.provincesdata[p].avePop.ancestry.color.g)/255,
							f32(worldmap.data.provincesdata[p].avePop.ancestry.color.b)/255,
							f32(worldmap.data.provincesdata[p].avePop.ancestry.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .culture:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if worldmap.data.provincesdata[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(worldmap.data.provincesdata[p].avePop.culture.color.r)/255,
							f32(worldmap.data.provincesdata[p].avePop.culture.color.g)/255,
							f32(worldmap.data.provincesdata[p].avePop.culture.color.b)/255,
							f32(worldmap.data.provincesdata[p].avePop.culture.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .religion:
				builder : strings.Builder
				for p in worldmap.data.provincesdata {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", worldmap.data.provincesdata[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if worldmap.data.provincesdata[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(worldmap.data.provincesdata[p].avePop.religion.color.r)/255,
							f32(worldmap.data.provincesdata[p].avePop.religion.color.g)/255,
							f32(worldmap.data.provincesdata[p].avePop.religion.color.b)/255,
							f32(worldmap.data.provincesdata[p].avePop.religion.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break
		}
	}
}

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

//*
is_within :: proc(
	v1 : raylib.Vector2,
	r1 : raylib.Rectangle,
) -> bool {
	if  (v1.x > r1.x && v1.x < r1.x + r1.width) &&
		(v1.y > r1.y && v1.y < r1.y + r1.height) {
			return false
	}
	return true
}