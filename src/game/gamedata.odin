package game


//= Imports


//= Global
state     : Gamestate = .mainmenu
pauseMenu : bool = false
abort     : bool = false


//= Structures


//= Enumerations
Gamestate :: enum {
	mainmenu,
	choose,
	play,
	observer,
}