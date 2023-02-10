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
PLAY_WIDTH  :: 200
PLAY_HEIGHT :: 50


//= Procedures
draw_nationchooser :: proc() {
	centerpoint : raylib.Vector2 = { 0, f32(game.settings.windowHeight)/2 }
	topleft     : raylib.Vector2 = { 0, 0 }

	elementWidth  : f32 = f32(game.settings.windowWidth) / 4
	elementHeight : f32 = f32(game.settings.windowHeight)
	topright      : raylib.Vector2 = { f32(game.settings.windowWidth) - elementWidth, 0 }
	botleft       : raylib.Vector2 = { 0, f32(game.settings.windowHeight) - PLAY_HEIGHT }
	
	builder : strings.Builder

	if game.player.currentSelection.owner != nil {
		//* Play
		play := elements.draw_button(
			{
				botleft.x + 25,
				botleft.y - 25,
				PLAY_WIDTH, PLAY_HEIGHT,
			},
			&game.general_textbox,
			&game.general_textbox_npatch,
			raylib.WHITE,
			raylib.GRAY,
			&game.font,
			game.settings.fontSize,
			raylib.BLACK,
			&game.localization["play"],
		)

		//* BG
		raylib.DrawTextureNPatch(
			game.general_textbox,
			game.general_textbox_npatch,
			{ topright.x, topright.y, elementWidth, elementHeight },
			{0,0}, 0,
			raylib.RAYWHITE,
		)

		//* Name
		name         := game.localization[game.player.currentSelection.owner.localID]
		nameWidth    := f32(len(name)) * (game.settings.fontSize + 8)
		namePosition := (elementWidth / 2) - (nameWidth / 2)
		raylib.DrawTextEx(
			game.font,
			name,
			{ topright.x + namePosition, topright.y + 20 },
			game.settings.fontSize + 8, 0,
			raylib.BLACK,
		)

		//* Flag
		flagPosition := (elementWidth / 2) - 50
		raylib.DrawTexturePro(
			game.player.currentSelection.owner.flag,
			{
				0,0,
				f32(game.player.currentSelection.owner.flag.width), f32(game.player.currentSelection.owner.flag.height),
			},
			{ topright.x + flagPosition, topright.y + 50, 100, 60 },
			{ 0, 0 },
			0,
			raylib.WHITE,
		)

		if play {
			game.player.nation = game.player.currentSelection.owner
			//TODO Create function for this
			game.player.currentSelection = nil
			shaderVariable := [4]f32{ 255, 255, 255, 255 }
			worldmap.change_shader_variable("chosenProv", shaderVariable)
			game.state = .play
		}
	}
}