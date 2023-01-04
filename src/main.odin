package main


//= Imports
import "vendor:raylib"

import "debug"
import "graphics"
import "graphics/ui"
import "game/player"
import "game/localization"
import "game/settings"
import "testing"


//= global
abort : bool = false


//= Update
main_update :: proc() {
	player.update()
}


//= Draw
main_draw :: proc() {

	//* Begin drawing and clear the background
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)

	//= Debug
	raylib.DrawFPS(0,0)

	result := ui.draw_mainmenu()
	switch result {
		case ui.out_quit:     abort = true
		case ui.out_newgame:
		case ui.out_loadgame:
		case ui.out_options:
		case ui.out_mods:
	}

	//* End drawing
	raylib.EndDrawing()
}


//= Main
main :: proc() {

	main_init()
	defer main_free()

	for !raylib.WindowShouldClose() && !abort {
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