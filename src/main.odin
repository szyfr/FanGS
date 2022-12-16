package main


//= Imports
import "vendor:raylib"

import "debug"
import "game/player"
import "settings"
import "testing"


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

	//* End drawing
	raylib.EndDrawing()
}


//= Main
main :: proc() {

	main_init()
	defer main_free()

	for !raylib.WindowShouldClose() /*&& !gamedata.abort*/ { //TODO
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

	//* Player
	player.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		settings.data.windowWidth,
		settings.data.windowHeight,
		"FanGS: Fantasy Grande Strategy",
	)
	raylib.SetTargetFPS(settings.data.targetFPS)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	//* Graphics


	//* Testing
	testing.test()
}


//= Free
main_free :: proc() {

	raylib.CloseWindow()

	settings.close()
	player.close()

}