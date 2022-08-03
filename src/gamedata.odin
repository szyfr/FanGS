package main


//= Imports
import "raylib"

import "localization"
import "settings"


//= Global Variables
gamedata : ^GameData


//= Structures
GameData :: struct {
	settings     : ^settings.SettingsData,
	localization : ^localization.LocalizationData,
}


//= Procedures

//* Reification
main_initialization :: proc() {

	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE))

	gamedata = new(GameData)

	gamedata.settings     = settings.init()
	gamedata.localization = localization.init(i32(gamedata.settings.language))
//	init_gamestate()
//	init_player()

	raylib.init_window(
		gamedata.settings.windowWidth,
		gamedata.settings.windowHeight,
		"FanGS: Fantasy Grande Strategy",
	)
	raylib.set_target_fps(gamedata.settings.targetFPS)
	
//	init_graphics()
//	init_gui()

}
main_free :: proc() {

	raylib.close_window();

	settings.free(gamedata.settings);
	localization.free(gamedata.localization);
//	free_graphics();
//	free_gui();
//	free_gamestate();
//	free_player();

//	print_log();

}