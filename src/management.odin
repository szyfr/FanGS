package main


//= Imports
import "core:fmt"

import "raylib"

import "gamedata"
import "graphics"
import "gui"
import "gui_effects"
import "localization"
import "logging"
import "player"
import "settings"
import "worldmap"

import "guinew"


//= Procedures

//* Reification
main_initialization :: proc() {
	using gamedata

	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE))

	settings.init()
	localization.init(i32(settingsdata.language))
	player.init()

	raylib.init_window(
		settingsdata.windowWidth,
		settingsdata.windowHeight,
		"FanGS: Fantasy Grande Strategy",
	)
	raylib.set_target_fps(settingsdata.targetFPS)
	
	graphics.init()
	gui.init()


	//* Titlescreen
	// TODO: migrate over to title screen
	guidata.titleScreen = true

	// Title
	guinew.create_label(
		position = {40,40},
		fontSize =  40,
		text     = &localizationdata.title,
	)
	// Menu
	guinew.create_button(
		transform = {10, 300, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.newGame,
		effect    =  gui_effects.start_new_game,
	)
	guinew.create_button(
		transform = {10, 360, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.loadGame,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 420, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.mods,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 480, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.options,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 540, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.quit,
		effect    =  gui_effects.quit_game,
	)

}
main_free :: proc() {

	raylib.close_window()

	settings.free_data()
	localization.free_data()
	graphics.free_data()
	gui.free_data()
	player.free_data()

	logging.print_log()

}

init_map :: proc() {}