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
import "date"


//= Main
main :: proc() {

	main_initialization()
	defer main_free()

	for !raylib.WindowShouldClose() && !gamedata.abort {
		//* Logic
		player.update()
		guinew.update()
		if !gamedata.titleScreen {
			date.update()
		}

		//* Graphics
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)

		if !gamedata.titleScreen {
			raylib.BeginMode3D(gamedata.playerdata.camera)
			raylib.DrawGrid(100, 10)

			worldmap.draw_provinces()

			raylib.EndMode3D()
		}
		guinew.draw()

		//* Province view GUI
		if gamedata.playerdata.currentSelection != nil do guinew.draw_province_view()

		raylib.DrawFPS(0,0)

		if !gamedata.titleScreen {
			builder : strings.Builder = {}
			str  := fmt.sbprintf(&builder, "%i", gamedata.worlddata.date.day)
			cstr := strings.clone_to_cstring(str)
			raylib.DrawText(
				cstr,
				100,100,
				20,
				raylib.BLACK,
			)

			if gamedata.worlddata.timePause do raylib.DrawTexture(gamedata.graphicsdata.box, 0, 0, raylib.RED)
			switch gamedata.worlddata.timeSpeed {
				case 0:
					raylib.DrawTexture(gamedata.graphicsdata.box, 0, 100, raylib.BLACK)
					fallthrough
				case 1:
					raylib.DrawTexture(gamedata.graphicsdata.box, 0, 200, raylib.BLACK)
					fallthrough
				case 2:
					raylib.DrawTexture(gamedata.graphicsdata.box, 0, 300, raylib.BLACK)
					fallthrough
				case 3:
					raylib.DrawTexture(gamedata.graphicsdata.box, 0, 400, raylib.BLACK)
					fallthrough
				case 4:
					raylib.DrawTexture(gamedata.graphicsdata.box, 0, 500, raylib.BLACK)
			}
		}

		raylib.EndDrawing()
	}
}