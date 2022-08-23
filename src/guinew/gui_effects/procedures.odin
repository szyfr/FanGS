package gui_effects


//= Imports
import "../../gamedata"
import "../../guinew"
import "../../worldmap"


//= Procedures

//* New game
start_new_game :: proc() {
	gamedata.titleScreen = false

	//? Titlescreen UI
	guinew.remove(0)
	guinew.remove(1)
	guinew.remove(2)
	guinew.remove(3)
	guinew.remove(4)
	guinew.remove(5)

//	if !gamedata.titleScreen && gamedata.mapdata == nil do worldmap.init(gamedata.selectedMap)
//	if !gamedata.titleScreen && gamedata.mapdata == nil do worldmap.init("anbennar")
//	worldmap.init(gamedata.selectedMap)
	worldmap.init("anbennar")
}

//* Load game

//* Mods

//* Options

//* Quit
quit_game :: proc() {
	gamedata.abort = true
}
