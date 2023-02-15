package worldmap


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../../game"


//= Procedures
draw :: proc() {
	world := game.worldmap.worlds[game.worldmap.activeWorld]
	//* Center
	raylib.DrawModelEx(
		world.model,
		{},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Left
	raylib.DrawModelEx(
		world.model,
		{-world.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Right
	raylib.DrawModelEx(
		world.model,
		{world.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)

	//TODO Province names
}