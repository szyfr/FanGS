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
		if game.menu == .pause	do game.menu = .none
		else					do game.menu = .pause
	}
}

//* Player movement
update_player_movement :: proc() {

	world	:= game.worldmap.worlds[game.worldmap.activeWorld]
	mod		:= ((game.player.zoom) / 5) / 100

	//* Key Movement
	if settings.is_key_down("up")    do game.player.target.z   += MOVE_SPD * (mod+3)
	if settings.is_key_down("down")  do game.player.target.z   -= MOVE_SPD * (mod+3)
	if settings.is_key_down("left")  do game.player.target.x   += MOVE_SPD * (mod+3)
	if settings.is_key_down("right") do game.player.target.x   -= MOVE_SPD * (mod+3)

	//* Drag movement
	if settings.is_key_down("grabmap") {
		mouseDelta: raylib.Vector2 = raylib.GetMouseDelta()

		game.player.target.x += mouseDelta.x * mod
		game.player.target.z += mouseDelta.y * mod
	}

	//* Edge scrolling
	if game.settings.edgeScrolling {
		if raylib.GetMouseX() <= EDGE_DIS do game.player.target.x   += MOVE_SPD
		if raylib.GetMouseY() <= EDGE_DIS do game.player.target.z   += MOVE_SPD
		if raylib.GetMouseX() >= game.settings.windowWidth - EDGE_DIS  do game.player.target.x -= MOVE_SPD
		if raylib.GetMouseY() >= game.settings.windowHeight - EDGE_DIS do game.player.target.z -= MOVE_SPD
	}

	//* Edge contraints/looping
	if game.worldmap != nil {
		if game.player.target.z >  0					do game.player.target.z =  0
		if game.player.target.z < -world.mapHeight		do game.player.target.z = -world.mapHeight

		if game.worldmap.settings.loopMap {
			if game.player.target.x > 0					do game.player.target.x = -world.mapWidth
			if game.player.target.x < -world.mapWidth	do game.player.target.x = 0
		} else {
			if game.player.target.x > 0					do game.player.target.x = 0
			if game.player.target.x < -world.mapWidth	do game.player.target.x = -world.mapWidth
		}
	}
}

//* Player camera
update_player_camera :: proc() {

	//* Zoom
	if      settings.is_key_pressed("zoompos") do game.player.zoom -= 2
	else if settings.is_key_pressed("zoomneg") do game.player.zoom += 2
	
	if game.player.zoom > ZOOM_MAX do game.player.zoom = ZOOM_MAX;
	if game.player.zoom < ZOOM_MIN do game.player.zoom = ZOOM_MIN;

	if game.player.cameraSlope.x != 0	do game.player.position.x = game.player.target.x + game.player.zoom / game.player.cameraSlope.x
	else								do game.player.position.x = game.player.target.x
	if game.player.cameraSlope.y != 0	do game.player.position.y = game.player.target.y + game.player.zoom / game.player.cameraSlope.y
	else								do game.player.position.y = game.player.target.y
	if game.player.cameraSlope.z != 0	do game.player.position.z = game.player.target.z + game.player.zoom / game.player.cameraSlope.z
	else								do game.player.position.z = game.player.target.z
	
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
				elementWidth  : f32 = f32(game.settings.windowWidth) / 4
				elementHeight : f32 = f32(game.settings.windowHeight)
				topright      : f32 = f32(game.settings.windowWidth) - elementWidth
				botleft       : f32 = f32(game.settings.windowHeight) - 50
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

		world := game.worldmap.worlds[game.worldmap.activeWorld]

		//* Creating ray and collision info
		game.player.ray = raylib.GetMouseRay(position, game.player)
		collision : raylib.RayCollision = {}
		width, height := -world.mapWidth/2, -world.mapHeight/2
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
			-world.mapWidth, 0, 0, 1,
		}
		transformRight : linalg.Matrix4x4f32 = {
			-1, 0,  0, 0,
			 0, 1,  0, 0,
			 0, 0, -1, 0,
			+world.mapWidth, 0, 0, 1,
		}

		//* Casting ray
		collision = raylib.GetRayCollisionMesh(
			game.player.ray,
			world.collisionMesh,
			transformCenter,
		)
		if !collision.hit {
			collision = raylib.GetRayCollisionMesh(
				game.player.ray,
				world.collisionMesh,
				transformLeft,
			)
			if !collision.hit {
				collision = raylib.GetRayCollisionMesh(
					game.player.ray,
					world.collisionMesh,
					transformRight,
				)
			}
		}

		//* Calculate PosX
		posX : i32
		if collision.point.x*20 > 0 do posX =  i32(world.mapWidth*20) - i32(collision.point.x*20)
		else                        do posX = -i32(collision.point.x*20) % i32(world.mapWidth*20)

		//* Grab color
		col := raylib.GetImageColor(
			world.provinceImage,
			posX,
			-i32(collision.point.z*20),
		)

		//* Set selected province
		prov, res := &game.provinces[col]
		if res && prov.type != game.ProvinceType.impassable {
			game.player.currentSelection = prov
			shaderVariable := [4]f32{
				f32(col.r) / 255,
				f32(col.g) / 255,
				f32(col.b) / 255,
				f32(col.a) / 255,
			}
			worldmap.change_shader_variable("chosenProv", shaderVariable)
		} else {
			game.player.currentSelection = nil
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
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{
						f32(game.provinces[p].color.r)/255,
						f32(game.provinces[p].color.g)/255,
						f32(game.provinces[p].color.b)/255,
						f32(game.provinces[p].color.a)/255,
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .political:
				builder : strings.Builder
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }

					if game.provinces[p].owner != nil {
						shaderVariable = [4]f32{
							f32(game.provinces[p].owner.color.r)/255,
							f32(game.provinces[p].owner.color.g)/255,
							f32(game.provinces[p].owner.color.b)/255,
							f32(game.provinces[p].owner.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .terrain:
				builder : strings.Builder
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{
						f32(game.provinces[p].terrain.color.r)/255,
						f32(game.provinces[p].terrain.color.g)/255,
						f32(game.provinces[p].terrain.color.b)/255,
						f32(game.provinces[p].terrain.color.a)/255,
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .control:
				builder : strings.Builder
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable : [4]f32
					#partial switch game.provinces[p].type {
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
				for p in game.provinces {
					count := game.provinces[p].avePop.count
					if maxPopulation < count do maxPopulation = count
					fmt.printf("",count)
				}
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }
					if maxPopulation > 0 && game.provinces[p].type != .impassable {
						populationRatio : f32 = f32(game.provinces[p].avePop.count) / f32(maxPopulation)
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
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					infraRatio     := f32(game.provinces[p].curInfrastructure) / f32(game.provinces[p].maxInfrastructure)
					shaderVariable := [4]f32{ 0.75, 0.75, 0.75, 1 }
					if game.provinces[p].type != .impassable {
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
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if game.provinces[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(game.provinces[p].avePop.ancestry.color.r)/255,
							f32(game.provinces[p].avePop.ancestry.color.g)/255,
							f32(game.provinces[p].avePop.ancestry.color.b)/255,
							f32(game.provinces[p].avePop.ancestry.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .culture:
				builder : strings.Builder
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if game.provinces[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(game.provinces[p].avePop.culture.color.r)/255,
							f32(game.provinces[p].avePop.culture.color.g)/255,
							f32(game.provinces[p].avePop.culture.color.b)/255,
							f32(game.provinces[p].avePop.culture.color.a)/255,
						}
					}
					worldmap.change_shader_variable(shaderVarName, shaderVariable)
					strings.builder_reset(&builder)
				}
				break

			case .religion:
				builder : strings.Builder
				for p in game.provinces {
					shaderVarName  := fmt.sbprintf(&builder, "prov[%i].mapColor", game.provinces[p].localID)
					shaderVariable := [4]f32{ 1, 1, 1, 1 }
					if game.provinces[p].avePop != {} {
						shaderVariable = [4]f32{
							f32(game.provinces[p].avePop.religion.color.r)/255,
							f32(game.provinces[p].avePop.religion.color.g)/255,
							f32(game.provinces[p].avePop.religion.color.b)/255,
							f32(game.provinces[p].avePop.religion.color.a)/255,
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
	if settings.is_key_pressed("pause") do game.worldmap.timePause = !game.worldmap.timePause
	if settings.is_key_pressed("faster") {
		switch game.worldmap.timeSpeed {
			case 1: game.worldmap.timeSpeed = 0
			case 2: game.worldmap.timeSpeed = 1
			case 3: game.worldmap.timeSpeed = 2
			case 4: game.worldmap.timeSpeed = 3
		}
	}
	if settings.is_key_pressed("slower") {
		switch game.worldmap.timeSpeed {
			case 0: game.worldmap.timeSpeed = 1
			case 1: game.worldmap.timeSpeed = 2
			case 2: game.worldmap.timeSpeed = 3
			case 3: game.worldmap.timeSpeed = 4
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