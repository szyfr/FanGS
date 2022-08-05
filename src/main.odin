package main


//= Import
import "core:fmt"
import "core:strings"

import "raylib"

import "gui"
import "player"


//= Main
main :: proc() {

	main_initialization()

	for !raylib.window_should_close() {
		//* Logic
		player.update(gamedata.playerdata, gamedata.settingsdata)
		gui.update_elements(gamedata.guidata)

		//* Graphics
		raylib.begin_drawing()
		raylib.clear_background(raylib.RAYWHITE)

		if !gamedata.titleScreen {
			raylib.begin_mode3d(gamedata.playerdata.camera)
			raylib.draw_grid(100, 1)
			raylib.end_mode3d()
		} else {
			gui.draw_elements(gamedata.guidata.elements)
		}

		raylib.draw_fps(0,0)

		raylib.end_drawing()
	}

	main_free()
}