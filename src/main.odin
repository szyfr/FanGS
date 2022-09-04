package main


//= Import
import "core:time"
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "gamedata"
import "guinew"
import "player"
import "worldmap"


//= Main
main :: proc() {

	main_initialization()
	defer main_free()

	for !raylib.WindowShouldClose() && !gamedata.abort {
		//* Logic
		player.update()
		guinew.update()

		//* Graphics
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)

		if !gamedata.titleScreen {
			raylib.BeginMode3D(gamedata.playerdata.camera)
			raylib.DrawGrid(100, 10)

			worldmap.draw_map()

			raylib.EndMode3D()
		}
		guinew.draw()

		//* Province GUI Test
		if gamedata.playerdata.currentSelection != nil do guinew.draw_province_view()

		raylib.DrawFPS(0,0)

		raylib.EndDrawing()
	}
}