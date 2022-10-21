package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../gamedata"


//= Constants
OPTIONS_WIDTH  : f32 : 600
OPTIONS_HEIGHT : f32 : 500


//= Procedures
draw_options_menu :: proc() {
	using gamedata, raylib

	centerpoint : Vector2 = { f32(settingsdata.windowWidth)/2, f32(settingsdata.windowHeight)/2 }
	topleft     : Vector2 = { centerpoint.x - (OPTIONS_WIDTH/2), centerpoint.y - (OPTIONS_HEIGHT/2) }

	//* Background
	DrawTextureNPatch(
		graphicsdata.box,
		graphicsdata.box_nPatch,
		{topleft.x, topleft.y, OPTIONS_WIDTH, OPTIONS_HEIGHT},
		{0,0}, 0,
		RAYWHITE,
	)
}