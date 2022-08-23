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
			raylib.DrawGrid(100, 1)

			worldmap.draw_map()

			raylib.EndMode3D()
		}
		guinew.draw()

		raylib.DrawFPS(0,0)

		raylib.EndDrawing()
	}
}