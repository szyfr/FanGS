package main


//= Imports
import "core:fmt"

import "raylib"

import "gamedata"
import "graphics"
import "guinew"
import "guinew/gui_presets"
import "guinew/gui_effects"
import "localization"
import "logging"
import "player"
import "settings"
import "worldmap"



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

	gui_presets.create_titlescreen()

}
main_free :: proc() {

	raylib.close_window()

	settings.free_data()
	localization.free_data()
	graphics.free_data()
	player.free_data()
	guinew.remove_all()

	logging.print_log()

}

init_map :: proc() {}