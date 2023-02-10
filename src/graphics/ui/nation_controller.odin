package ui


//= Imports
import "core:fmt"
import "core:strconv"
import "core:strings"

import "vendor:raylib"

import "../../game"
import "../../game/date"
import "../../game/player"
import "../../game/settings"
import "../../game/localization"
import "../../game/provinces"
import "elements"
import "../worldmap"


//= Constants


//= Procedures
draw_nationcontroller :: proc() {

	raylib.DrawTexturePro(
		game.player.nation.flag,
		{
			0,0,
			f32(game.player.nation.flag.width), f32(game.player.nation.flag.height),
		},
		{ 25, 25, 100, 60 },
		{ 0, 0 },
		0,
		raylib.WHITE,
	)
}