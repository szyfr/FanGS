package ui


//= Imports
import "core:fmt"
import "core:strconv"
import "core:strings"

import "vendor:raylib"

import "elements"
import "../worldmap"
import "../../game"
import "../../game/date"
import "../../game/player"
import "../../game/settings"
import "../../game/localization"
import "../../game/provinces"
import "../../graphics"


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
	name := fmt.sbprintf(&builder, "%v", player.data.currentSelection.localID)
	raylib.DrawTextEx(
		graphics.font,
		localization.data[name],
		{topLeft.x + 20, topLeft.y + 20},
		settings.data.fontSize, 0,
		raylib.BLACK,
	)

	//* Terrain
	terrain : string
	#partial switch player.data.currentSelection.terrain {
		case provinces.Terrain.grassland: terrain = "grassland"
		case provinces.Terrain.cave: terrain      = "cave"
		case provinces.Terrain.drow_hold: terrain = "drow_hold"
	}
	raylib.DrawTextEx(
		graphics.font,
		localization.data[terrain],
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

//	//* Populations
//	if gamedata.playerdata.currentSelection.provType == .base {
//		str = fmt.sbprintf(
//			&builder,
//			"%v | %v - %v - %v\n",
//			gamedata.playerdata.currentSelection.avePop.pop,
//			gamedata.playerdata.currentSelection.avePop.ancestry,
//			gamedata.playerdata.currentSelection.avePop.culture,
//			gamedata.playerdata.currentSelection.avePop.religion,
//		)
//		raylib.DrawTextEx(
//			gamedata.graphicsdata.font,
//			strings.clone_to_cstring(str),
//			{topLeft.x + 20, topLeft.y + 120},
//			gamedata.settingsdata.fontSize, 0,
//			raylib.BLACK,
//		)
//	}
	
	delete(str)
}