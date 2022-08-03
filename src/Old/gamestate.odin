package main



//= Imports

//= Constants

//= Global Variables
gamestate: ^Gamestate;


//= Structures
Gamestate :: struct {
	titleScreen: bool,
}


//= Enumerations

//= Procedures

init_gamestate :: proc() {
	gamestate = new(Gamestate);

	gamestate.titleScreen = true;
}
free_gamestate :: proc() {
	free(gamestate);
}