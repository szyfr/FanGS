package gui_effects


//= Imports
import "../gamedata"
import "../gui"
import "../guinew"


//= Procedures

//* New game
start_new_game :: proc() {
	gamedata.guidata.titleScreen = false

	guinew.remove_all()
}

//* Load game

//* Mods

//* Options

//* Quit
quit_game :: proc() {
	gamedata.guidata.abort = true
}
