package gui_effects


//= Imports
import "../gamedata"
import "../gui"


//= Procedures

//* New game
start_new_game :: proc(guidata : ^gamedata.GuiData, index : i32) {
	guidata.titleScreen = false
	gui.delete_all(guidata)
}

//* Load game

//* Mods

//* Options

//* Quit
quit_game :: proc(guidata : ^gamedata.GuiData, index : i32) {
	guidata.abort = true
}
