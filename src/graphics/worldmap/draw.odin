package worldmap


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc() {

	//* Center
	raylib.DrawModelEx(
		game.worldmap.model,
		{},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Left
	raylib.DrawModelEx(
		game.worldmap.model,
		{-game.worldmap.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Right
	raylib.DrawModelEx(
		game.worldmap.model,
		{game.worldmap.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)

	//TODO Province names
}