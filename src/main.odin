package main


//= Imports
import "core:fmt"

import "vendor:raylib"

import "debug"

import "game"
import "game/date"
import "game/player"
import "game/localization"
import "game/settings"

import "graphics"
import "graphics/worldmap"
import "graphics/ui"



//= Update
main_update :: proc() {
	#partial switch game.state {
		case .mainmenu:
		case .choose:
			player.update()
		case .play:
			player.update()
			date.update()
		case .observer:
			player.update()
			date.update()
	}

	if raylib.IsKeyPressed(.O) {
		for str in game.mods {
			fmt.printf("%v\n", str)
		}
	}
}


//= Draw
main_draw :: proc() {

	//* Begin drawing and clear the background
	raylib.BeginDrawing()
	raylib.ClearBackground(raylib.RAYWHITE)
	
	//* 3D elements
	raylib.BeginMode3D(game.player)
	#partial switch game.state {
		case .mainmenu:
		case .choose:
			worldmap.draw()
		case .play:
			worldmap.draw()
		case .observer:
			worldmap.draw()
	}
	raylib.EndMode3D()

	//* 2D GUI
	#partial switch game.state {
		case .mainmenu:
			result := ui.draw_mainmenu()
			switch result {
				case ui.out_quit:     game.abort = true
				case ui.out_newgame:
				case ui.out_loadgame:
				case ui.out_options:
				case ui.out_mods:
			}
			if game.menu == .mods	do ui.draw_modmenu()

		case .choose:
			if game.menu == .pause	do ui.draw_pausemenu()
			if game.player.currentSelection != nil do ui.draw_nationchooser()

		case .play:
			ui.draw_datedisplay()
			ui.draw_nationcontroller()
			if game.menu == .pause do ui.draw_pausemenu()
			if game.player.currentSelection != nil do ui.draw_provincemenu()

		case .observer:
			ui.draw_datedisplay()
			ui.draw_nationcontroller()
			if game.menu == .pause do ui.draw_pausemenu()
			if game.player.currentSelection != nil do ui.draw_provincemenu()
	}

	//* Debug
	raylib.DrawFPS(0,0)

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
	//* Debugging
	debug.create_log()

	//* Setup
	settings.init()
	localization.init()

	//* Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		game.settings.windowWidth,
		game.settings.windowHeight,
		game.localization["game_desc"],
	)
	raylib.SetTargetFPS(game.settings.targetFPS)
	raylib.SetExitKey(raylib.KeyboardKey.NULL)

	//* Graphics
	graphics.init()
	
	//* Data
	player.init()
	append(&game.mods, "farophi")
}


//= Free
main_free :: proc() {

	raylib.CloseWindow()

	settings.close()
	localization.close()
	player.close()
	graphics.close()

}