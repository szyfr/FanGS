package main


//= Import
import "core:time"
import "core:fmt"
import "core:strings"

import "raylib"

import "gamedata"
import "guinew"
import "player"
import "worldmap"



//= Main
main :: proc() {

	main_initialization()
	defer main_free()

	for !raylib.window_should_close() && !gamedata.abort {
		//* Logic
		player.update()
		guinew.update()
		
	//	if !gamedata.titleScreen && gamedata.mapdata == nil do worldmap.init(gamedata.selectedMap)
		if !gamedata.titleScreen && gamedata.mapdata == nil do worldmap.init("anbennar")

		//* Graphics
		raylib.begin_drawing()
		raylib.clear_background(raylib.RAYWHITE)

		if !gamedata.titleScreen {
			raylib.begin_mode3d(gamedata.playerdata.camera)
			raylib.draw_grid(100, 1)

			worldmap.draw_map()

			raylib.end_mode3d()
		}
		guinew.draw()

		raylib.draw_fps(0,0)

		raylib.end_drawing()
	}
}