package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../gamedata"
import "../worldmap"


//= Constants
MAIN_WIDTH  : f32 : 200
MAIN_HEIGHT : f32 : 320
MAIN_BUTTON_WIDTH  : f32 : 250
MAIN_BUTTON_HEIGHT : f32 :  60


//= Procedures
draw_main_menu :: proc() {
	using gamedata, raylib

	centerpoint : Vector2 = { 0, f32(settingsdata.windowHeight)/2 }
	topleft     : Vector2 = { 0, 0 }

	//* Drawing title
	raylib.DrawTextEx(
		graphicsdata.font,
		localizationdata.title,
		topleft + 50,
		40, 1,
		BLACK,
	)

	//* Drawing buttons
	new := draw_button_new(
		{
			centerpoint.x+25,
			centerpoint.y-100,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		WHITE,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		localizationdata.newGame,
	)
	load := draw_button_new(
		{
			centerpoint.x+25,
			centerpoint.y-25,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		localizationdata.loadGame,
	)
	mods := draw_button_new(
		{
			centerpoint.x+25,
			centerpoint.y+50,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		localizationdata.mods,
	)
	options := draw_button_new(
		{
			centerpoint.x+25,
			centerpoint.y+125,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		localizationdata.options,
	)
	quit := draw_button_new(
		{
			centerpoint.x+25,
			centerpoint.y+200,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		WHITE,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		localizationdata.quit,
	)

	//* Button logic
	if new     {
		titleScreen = false
		worldmap.init("anbennar")
	}
	if load    {} // TODO
	if mods    {} // TODO
	if options {} // TODO: do optionsmenu = true
	if quit    do abort = true
}