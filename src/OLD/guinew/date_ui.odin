package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../date"
import "../gamedata"


//= Procedures
draw_date_ui :: proc() {
	using gamedata

	posX : f32 = f32(settingsdata.windowWidth) - 144
	posY : f32 = 5
	off  : f32 = 16

	raylib.DrawTextEx(
		graphicsdata.font,
		date.to_string(),
		{posX-24,posY},
		16,
		1,
		raylib.BLACK,
	)

	if gamedata.worlddata.timePause do raylib.DrawTextureEx(
		gamedata.graphicsdata.box_small,
		{posX, posY+off},
		0, 1,
		raylib.RED,
	)

	switch gamedata.worlddata.timeSpeed {
		case 0:
			raylib.DrawTextureEx(
				gamedata.graphicsdata.box_small,
				{posX+24, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 1:
			raylib.DrawTextureEx(
				gamedata.graphicsdata.box_small,
				{posX+48, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 2:
			raylib.DrawTextureEx(
				gamedata.graphicsdata.box_small,
				{posX+72, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 3:
			raylib.DrawTextureEx(
				gamedata.graphicsdata.box_small,
				{posX+96, posY+off},
				0, 1,
				raylib.BLACK,
			)
			fallthrough
		case 4:
			raylib.DrawTextureEx(
				gamedata.graphicsdata.box_small,
				{posX+120, posY+off},
				0, 1,
				raylib.BLACK,
			)
	}
}