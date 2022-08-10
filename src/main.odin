package main


//= Import
import "core:time"
import "core:fmt"
import "core:strings"

import "raylib"

import "gui"
import "player"
import "worldmap"


//= Main
main :: proc() {

	main_initialization()

	for !raylib.window_should_close() && !gamedata.guidata.abort {
		//* Logic
		player.update(gamedata.playerdata, gamedata.settingsdata)
		gui.update_elements(gamedata.guidata)
		
	//	if !gamedata.guidata.titleScreen && gamedata.mapdata == nil do gamedata.mapdata = worldmap.init(gamedata.guidata.selectedMap)
		if !gamedata.guidata.titleScreen && gamedata.mapdata == nil do gamedata.mapdata = worldmap.init("anbennar")

		//* Graphics
		raylib.begin_drawing()
		raylib.clear_background(raylib.RAYWHITE)

		if !gamedata.guidata.titleScreen {
			raylib.begin_mode3d(gamedata.playerdata.camera)
			raylib.draw_grid(100, 1)

			for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
			//	raylib.draw_model(
			//		gamedata.mapdata.chunks[i].model,
			//		gamedata.mapdata.chunks[i],
			//		1, raylib.WHITE,
			//	)
				raylib.draw_model_ex(
					gamedata.mapdata.chunks[i].model,
					gamedata.mapdata.chunks[i],
					{0,1,0}, 180,
					{10.046, 5, 10.046},
			//		{10, 5, 10},
					raylib.WHITE,
				)
			}

			raylib.end_mode3d()
		} else {
			gui.draw_elements(gamedata.guidata.elements)
		}

		raylib.draw_fps(0,0)

		raylib.end_drawing()
	}

	main_free()
}