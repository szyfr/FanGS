package worldmap


//= Imports
import "core:fmt"

import "vendor:raylib"


//= Procedures
draw :: proc() {

	//* Center
	raylib.DrawModelEx(
		data.model,
		{},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Left
	raylib.DrawModelEx(
		data.model,
		{-data.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)
	//* Right
	raylib.DrawModelEx(
		data.model,
		{data.mapWidth,0,0},
		{0,1,0},
		180,
		{1,1,1},
		raylib.WHITE,
	)

	//TODO Province names
}