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
PROVIEW_WIDTH  : f32 : 300
PROVIEW_HEIGHT : f32 : 400


//= Procedures
draw_provincemenu :: proc() {
	topLeft := raylib.Vector2{0, f32(game.settings.windowHeight) - PROVIEW_HEIGHT}

	//* Background
	raylib.DrawTextureNPatch(
		game.general_textbox,
		game.general_textbox_npatch,
		{topLeft.x, topLeft.y, PROVIEW_WIDTH, PROVIEW_HEIGHT},
		{0,0}, 0,
		raylib.RAYWHITE,
	)

	builder : strings.Builder

	//* Province name
	raylib.DrawTextEx(
		game.font,
		game.player.currentSelection.name^,
		{topLeft.x + 20, topLeft.y + 20},
		game.settings.fontSize, 0,
		raylib.BLACK,
	)

	//* Terrain
	raylib.DrawTextEx(
		game.font,
		game.player.currentSelection.terrain.name^,
		{topLeft.x + 40, topLeft.y + 40},
		game.settings.fontSize, 0,
		raylib.BLACK,
	)

	//* Province Type
	type : string
	switch game.player.currentSelection.type {
		case .NULL:         type = "NULL"
		case .base:         type = "base"
		case .controllable: type = "controllable"
		case .ocean:        type = "ocean"
		case .lake:         type = "lake"
		case .impassable:   type = "impassable"
	}
	raylib.DrawTextEx(
		game.font,
		game.localization[type],
		{topLeft.x + 40, topLeft.y + 60},
		game.settings.fontSize, 0,
		raylib.BLACK,
	)

	//* Infrastructure
	strings.builder_reset(&builder)
	str     := fmt.sbprintf(
		&builder,
		"%v / %v",
		game.player.currentSelection.curInfrastructure,
		game.player.currentSelection.maxInfrastructure,
	)
	raylib.DrawTextEx(
		game.font,
		strings.clone_to_cstring(str),
		{topLeft.x + 40, topLeft.y + 80},
		game.settings.fontSize, 0,
		raylib.BLACK,
	)
	clear(&builder.buf)

	//* Populations
	if game.player.currentSelection.type == .base && game.player.currentSelection.avePop.count > 0 {
		str = fmt.sbprintf(
			&builder,
			"%v | %v - %v - %v\n",
			game.player.currentSelection.avePop.count,
			game.player.currentSelection.avePop.ancestry.name^,
			game.player.currentSelection.avePop.culture.name^,
			game.player.currentSelection.avePop.religion.name^,
		)
		raylib.DrawTextEx(
			game.font,
			strings.clone_to_cstring(str),
			{topLeft.x + 20, topLeft.y + 120},
			game.settings.fontSize, 0,
			raylib.BLACK,
		)
	}

	////* TEST
	//if game.player.currentSelection.owner != nil {
	//	raylib.DrawTextEx(
	//		game.font,
	//		"Owned",
	//		{topLeft.x + 20, topLeft.y + 160},
	//		game.settings.fontSize, 0,
	//		raylib.BLACK,
	//	)
	//}

	//delete(str)
}