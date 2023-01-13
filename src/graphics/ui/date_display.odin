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
import "../../graphics"


//= Constants


//= Procedures
draw_datedisplay :: proc() {
	posX : f32 = f32(settings.data.windowWidth) - 144
	posY : f32 = 5
	off  : f32 = 16

	raylib.DrawTextEx(
		graphics.font,
		date.to_string(),
		{posX-24,posY},
		16,
		1,
		raylib.BLACK,
	)

	if worldmap.data.timePause do raylib.DrawTextureEx(
		graphics.general_textbox_small,
		{posX, posY+off},
		0, 1,
		raylib.RED,
	)

	switch worldmap.data.timeSpeed {
		case 0:
			raylib.DrawTextureEx(
				graphics.general_textbox_small,
				{posX+24, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 1:
			raylib.DrawTextureEx(
				graphics.general_textbox_small,
				{posX+48, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 2:
			raylib.DrawTextureEx(
				graphics.general_textbox_small,
				{posX+72, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 3:
			raylib.DrawTextureEx(
				graphics.general_textbox_small,
				{posX+96, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 4:
			raylib.DrawTextureEx(
				graphics.general_textbox_small,
				{posX+120, posY+off},
				0, 1,
				raylib.BLACK,
			)
	}
}