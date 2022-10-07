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


//= Procedures
update :: proc() {
	
	player.update()
	guinew.update()

	if !gamedata.titleScreen {
		date.update()
	}

}

draw :: proc() {
	//* Begin drawing and clear the background
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)

	//= World drawing
	if !gamedata.titleScreen {
		raylib.BeginMode3D(gamedata.playerdata.camera)

		//* Draw map
		worldmap.draw_provinces()
		//! Remove at some point
		raylib.DrawGrid(100, 10)

		raylib.EndMode3D()
	}

	//= UI drawing
	//* General GUI
	guinew.draw()
	//* Province view GUI
	if gamedata.playerdata.currentSelection != nil do guinew.draw_province_view()
	//* Date GUI
	if !gamedata.titleScreen do guinew.draw_date_ui()

	//= Debug
	raylib.DrawFPS(0,0)

	//* End drawing
	raylib.EndDrawing()
}

main_loop :: proc() {
	for !raylib.WindowShouldClose() && !gamedata.abort {
		update()
		draw()
	}
}