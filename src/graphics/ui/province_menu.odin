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
import "../../graphics"
import "elements"
import "../worldmap"


//= Constants
PROVIEW_WIDTH  : f32 : 300
PROVIEW_HEIGHT : f32 : 400


//= Procedures
draw_provincemenu :: proc() {
	topLeft := raylib.Vector2{0, f32(settings.data.windowHeight) - PROVIEW_HEIGHT}

	//* Background
	raylib.DrawTextureNPatch(
		graphics.general_textbox,
		graphics.general_textbox_npatch,
		{topLeft.x, topLeft.y, PROVIEW_WIDTH, PROVIEW_HEIGHT},
		{0,0}, 0,
		raylib.RAYWHITE,
	)

	builder : strings.Builder

	//* Province name
	raylib.DrawTextEx(
		graphics.font,
		player.data.currentSelection.name^,
		{topLeft.x + 20, topLeft.y + 20},
		settings.data.fontSize, 0,
		raylib.BLACK,
	)

	//* Terrain
	raylib.DrawTextEx(
		graphics.font,
		player.data.currentSelection.terrain.name^,
		{topLeft.x + 40, topLeft.y + 40},
		settings.data.fontSize, 0,
		raylib.BLACK,
	)

	//* Province Type
	type : string
	switch player.data.currentSelection.type {
		case provinces.ProvinceType.NULL:         type = "NULL"
		case provinces.ProvinceType.base:         type = "base"
		case provinces.ProvinceType.controllable: type = "controllable"
		case provinces.ProvinceType.ocean:        type = "ocean"
		case provinces.ProvinceType.lake:         type = "lake"
		case provinces.ProvinceType.impassable:   type = "impassable"
	}
	raylib.DrawTextEx(
		graphics.font,
		localization.data[type],
		{topLeft.x + 40, topLeft.y + 60},
		settings.data.fontSize, 0,
		raylib.BLACK,
	)

	//* Infrastructure
	strings.builder_reset(&builder)
	str     := fmt.sbprintf(
		&builder,
		"%v / %v",
		player.data.currentSelection.curInfrastructure,
		player.data.currentSelection.maxInfrastructure,
	)
	raylib.DrawTextEx(
		graphics.font,
		strings.clone_to_cstring(str),
		{topLeft.x + 40, topLeft.y + 80},
		settings.data.fontSize, 0,
		raylib.BLACK,
	)
	clear(&builder.buf)

	//* Populations
	if player.data.currentSelection.type == .base && player.data.currentSelection.avePop.count > 0 {
		str = fmt.sbprintf(
			&builder,
			"%v | %v - %v - %v\n",
			player.data.currentSelection.avePop.count,
			player.data.currentSelection.avePop.ancestry.name^,
			player.data.currentSelection.avePop.culture.name^,
			player.data.currentSelection.avePop.religion.name^,
		)
		raylib.DrawTextEx(
			graphics.font,
			strings.clone_to_cstring(str),
			{topLeft.x + 20, topLeft.y + 120},
			settings.data.fontSize, 0,
			raylib.BLACK,
		)
	}

	////* TEST
	//if player.data.currentSelection.owner != nil {
	//	raylib.DrawTextEx(
	//		graphics.font,
	//		"Owned",
	//		{topLeft.x + 20, topLeft.y + 160},
	//		settings.data.fontSize, 0,
	//		raylib.BLACK,
	//	)
	//}

	//delete(str)
}