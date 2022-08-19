package gui_effects


//= Imports
import "../../gamedata"
import "../../guinew"


//= Procedures

//* New game
start_new_game :: proc() {
	gamedata.titleScreen = false

	guinew.remove_all()
}

//* Load game

//* Mods

//* Options

//* Quit
quit_game :: proc() {
	gamedata.abort = true
}
