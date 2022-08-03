package main


//= Import
import "core:fmt"
import "core:strings"

import "raylib"


//= Main
main :: proc() {

	main_initialization()

	for !raylib.window_should_close() {
		//* Logic
	//	update_player_movement()
	//	update_elements(gui.elements)

		//* Graphics
		raylib.begin_drawing()
		raylib.clear_background(raylib.RAYWHITE)

	//	if !gamestate.titleScreen {
	//		raylib.begin_mode3d(player.camera)
	//		raylib.draw_grid(100, 1)
	//		raylib.end_mode3d()
	//	} else {
	//		draw_elements(gui.elements)
	//	}

		raylib.draw_fps(0,0)

		raylib.end_drawing()
	}

	main_free()
}