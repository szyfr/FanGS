package main


//= Imports
import "raylib"

import "graphics"
import "gui"
import "gui_effects"
import "player"
import "localization"
import "logging"
import "settings"
import "worldmap"


//= Global Variables
gamedata : ^GameData


//= Structures
GameData :: struct {
	settingsdata     : ^settings.SettingsData,
	localizationdata : ^localization.LocalizationData,
	graphicsdata     : ^graphics.GraphicsData,
	guidata          : ^gui.GuiData,
	playerdata       : ^player.PlayerData,
	mapdata          : ^worldmap.MapData,
}


//= Procedures

//* Reification
main_initialization :: proc() {

	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE))

	gamedata = new(GameData)

	gamedata.settingsdata     = settings.init()
	gamedata.localizationdata = localization.init(i32(gamedata.settingsdata.language))
	gamedata.playerdata       = player.init()

	raylib.init_window(
		gamedata.settingsdata.windowWidth,
		gamedata.settingsdata.windowHeight,
		"FanGS: Fantasy Grande Strategy",
	)
	raylib.set_target_fps(gamedata.settingsdata.targetFPS)
	
	gamedata.graphicsdata = graphics.init()
	gamedata.guidata      = gui.init()


	//* Titlescreen
	// TODO: migrate over to title screen
	gamedata.guidata.titleScreen = true

	// Title
	append(&gamedata.guidata.elements, gui.create_label(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={40, 40, 200, 50},
		halignment=.left,
		fontSize=40,
		text="FanGS",
	))

	// Menu options
	append(&gamedata.guidata.elements, gui.create_button(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={10, 300, 250, 50},
		fontSize=20,
		text=gamedata.localizationdata.newGame,
		effect=gui_effects.start_new_game,
	))
	append(&gamedata.guidata.elements, gui.create_button(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={10, 360, 250, 50},
		fontSize=20,
		text=gamedata.localizationdata.loadGame,
	))
	append(&gamedata.guidata.elements, gui.create_button(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={10, 420, 250, 50},
		fontSize=20,
		text=gamedata.localizationdata.mods,
	))
	append(&gamedata.guidata.elements, gui.create_button(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={10, 480, 250, 50},
		fontSize=20,
		text=gamedata.localizationdata.options,
	))
	append(&gamedata.guidata.elements, gui.create_button(
		graphicsdata=gamedata.graphicsdata,
		settingsdata=gamedata.settingsdata,
		rectangle={10, 540, 250, 50},
		fontSize=20,
		text=gamedata.localizationdata.quit,
		effect=gui_effects.quit_game,
	))

}
main_free :: proc() {

	raylib.close_window()

	settings.free_data(gamedata.settingsdata)
	localization.free_data(gamedata.localizationdata)
	graphics.free_data(gamedata.graphicsdata)
	gui.free_data(gamedata.guidata);
	player.free_data(gamedata.playerdata)

	logging.print_log()

}

init_map :: proc() {}