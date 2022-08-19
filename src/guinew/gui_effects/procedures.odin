package gui_effects


//= Imports
import "../gui_presets"
import "../../gamedata"
import "../../guinew"


//= Procedures

//* New game
start_new_game :: proc() {
	gamedata.titleScreen = false

	gui_presets.delete_titlescreen()
}

//* Load game

//* Mods

//* Options

//* Quit
quit_game :: proc() {
	gamedata.abort = true
}
