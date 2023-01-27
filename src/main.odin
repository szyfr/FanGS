package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "debug"
import "graphics"
import "graphics/worldmap"
import "graphics/ui"
import "game"
import "game/date"
import "game/player"
import "game/localization"
import "game/settings"
import "testing"


//= Update
main_update :: proc() {
	if !game.mainMenu {
		player.update()
		date.update()
	}
}


//= Draw
main_draw :: proc() {

	//* Begin drawing and clear the background
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)
	
	//* 3D elements
	raylib.BeginMode3D(player.data)
	raylib.DrawGrid(100,10)

	if !game.mainMenu {
		worldmap.draw()
		raylib.DrawRay(player.data.ray, raylib.PURPLE)
	}
	
	raylib.EndMode3D()

	//* 2D GUI
	if game.mainMenu {
		result := ui.draw_mainmenu()
		switch result {
			case ui.out_quit:     game.abort = true
			case ui.out_newgame:
			case ui.out_loadgame:
			case ui.out_options:
			case ui.out_mods:
		}
	} else {
		ui.draw_datedisplay()
		if game.pauseMenu do ui.draw_pausemenu()
		if player.data.currentSelection != nil do ui.draw_provincemenu()
	}

	//= Debug
	raylib.DrawFPS(0,0)

	//* End drawing
	raylib.EndDrawing()
}


//= Main
main :: proc() {

	main_init()
	defer main_free()

	for !raylib.WindowShouldClose() && !game.abort {
		main_update()
		main_draw()
	}

}


//= Init
main_init :: proc() {

	//* Debugging system
	debug.create_log()

	//* Settings
	settings.init()

	//* Localization
	localization.init()

	//* Player
	player.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		settings.data.windowWidth,
		settings.data.windowHeight,
		localization.data["game_desc"],
	)
	raylib.SetTargetFPS(settings.data.targetFPS)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	//* Graphics
	graphics.init()

	//* Testing
	//testing.test()
}


//= Free
main_free :: proc() {

	raylib.CloseWindow()

	settings.close()
	localization.close()
	player.close()
	graphics.close()

}