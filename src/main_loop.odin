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
	using gamedata, raylib

	//* Begin drawing and clear the background
	BeginDrawing()
	ClearBackground(RAYWHITE)

	//= World drawing
	if !titleScreen {
		BeginMode3D(playerdata.camera)

		//* Draw map
		worldmap.draw_provinces()
		//! Remove at some point
		DrawGrid(100, 10)

		EndMode3D()
	}

	//= UI drawing
	//* General GUI
	guinew.draw()
	if pausemenu   do guinew.draw_pause_menu()
	if optionsmenu do guinew.draw_options_menu()
	//* Province view GUI
	if playerdata.currentSelection != nil do guinew.draw_province_view()
	//* Date GUI
	if !titleScreen do guinew.draw_date_ui()

	//= Debug
	DrawFPS(0,0)

	//* End drawing
	EndDrawing()
}

main_loop :: proc() {
	for !raylib.WindowShouldClose() && !gamedata.abort {
		update()
		draw()
	}
}