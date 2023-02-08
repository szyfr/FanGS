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
PLAY_WIDTH  :: 200
PLAY_HEIGHT :: 50


//= Procedures
draw_nationchooser :: proc() {
	centerpoint : raylib.Vector2 = { 0, f32(settings.data.windowHeight)/2 }
	topleft     : raylib.Vector2 = { 0, 0 }

	elementWidth  : f32 = f32(settings.data.windowWidth) / 4
	elementHeight : f32 = f32(settings.data.windowHeight)
	topright      : raylib.Vector2 = { f32(settings.data.windowWidth) - elementWidth, 0 }
	botleft       : raylib.Vector2 = { 0, f32(settings.data.windowHeight) - PLAY_HEIGHT }
	
	builder : strings.Builder

	if player.data.currentSelection.owner != nil {
		//* Play
		play := elements.draw_button(
			{
				botleft.x + 25,
				botleft.y - 25,
				PLAY_WIDTH, PLAY_HEIGHT,
			},
			&graphics.general_textbox,
			&graphics.general_textbox_npatch,
			raylib.WHITE,
			raylib.GRAY,
			&graphics.font,
			settings.data.fontSize,
			raylib.BLACK,
			&localization.data["play"],
		)

		//* BG
		raylib.DrawTextureNPatch(
			graphics.general_textbox,
			graphics.general_textbox_npatch,
			{ topright.x, topright.y, elementWidth, elementHeight },
			{0,0}, 0,
			raylib.RAYWHITE,
		)

		//* Name
		name         := localization.data[player.data.currentSelection.owner.localID]
		nameWidth    := f32(len(name)) * (settings.data.fontSize + 8)
		namePosition := (elementWidth / 2) - (nameWidth / 2)
		raylib.DrawTextEx(
			graphics.font,
			name,
			{ topright.x + namePosition, topright.y + 20 },
			settings.data.fontSize + 8, 0,
			raylib.BLACK,
		)

		//* Flag
		flagPosition := (elementWidth / 2) - 50
		raylib.DrawTexturePro(
			player.data.currentSelection.owner.flag,
			{
				0,0,
				f32(player.data.currentSelection.owner.flag.width), f32(player.data.currentSelection.owner.flag.height),
			},
			{ topright.x + flagPosition, topright.y + 50, 100, 60 },
			{ 0, 0 },
			0,
			raylib.WHITE,
		)

		if play {
			player.data.nation = player.data.currentSelection.owner
			//TODO Create function for this
			player.data.currentSelection = nil
			shaderVariable := [4]f32{ 255, 255, 255, 255 }
			worldmap.change_shader_variable("chosenProv", shaderVariable)
			game.state = .play
		}
	}
}