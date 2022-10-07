package main


//= Imports
import "core:fmt"
import "vendor:raylib"

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

	//* Create log
	logging.create_log()

	//* Init Settings
	settings.init()

	//* Init Localization
	localization.init(i32(settingsdata.language))

	//* Init Player
	player.init()

	//* Init Raylib
	raylib.SetTraceLogLevel(.NONE)
	raylib.InitWindow(
		settingsdata.windowWidth,
		settingsdata.windowHeight,
		"FanGS: Fantasy Grande Strategy",
	)
	raylib.SetTargetFPS(settingsdata.targetFPS)
	
	//* Init Graphics
	graphics.init()

	//* Generate titlescreen
	gui_presets.create_titlescreen()
}
main_free :: proc() {

	raylib.CloseWindow()

	settings.free_data()
	localization.free_data()
	graphics.free_data()
	player.free_data()
	guinew.remove_all()

}