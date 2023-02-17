package ui


//= Imports
import "core:fmt"
import "vendor:raylib"

import "elements"
import "../worldmap"
import "../../game"
import "../../game/date"
import "../../game/settings"
import "../../game/localization"


//= Constants


//= Procedures
draw_datedisplay :: proc() {
	posX : f32 = f32(game.settings.windowWidth) - 144
	posY : f32 = 5
	off  : f32 = 16

	raylib.DrawTextEx(
		game.font,
		date.to_string(),
		{posX-24,posY},
		game.settings.fontSize,
		1,
		raylib.BLACK,
	)

	if game.worldmap.timePause do raylib.DrawTextureEx(
		game.general_textbox_small,
		{posX, posY+off},
		0, 1,
		raylib.RED,
	)

	switch game.worldmap.timeSpeed {
		case 0:
			raylib.DrawTextureEx(
				game.general_textbox_small,
				{posX+24, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 1:
			raylib.DrawTextureEx(
				game.general_textbox_small,
				{posX+48, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 2:
			raylib.DrawTextureEx(
				game.general_textbox_small,
				{posX+72, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 3:
			raylib.DrawTextureEx(
				game.general_textbox_small,
				{posX+96, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 4:
			raylib.DrawTextureEx(
				game.general_textbox_small,
				{posX+120, posY+off},
				0, 1,
				raylib.BLACK,
			)
	}
}