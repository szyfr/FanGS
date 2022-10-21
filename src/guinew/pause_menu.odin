package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../gamedata"


//= Constants
PAUSE_WIDTH  : f32 : 200
PAUSE_HEIGHT : f32 : 320
PAUSE_BUTTON_WIDTH  : f32 : 180
PAUSE_BUTTON_HEIGHT : f32 :  50


//= Procedures
draw_pause_menu :: proc() {
	using gamedata, raylib

	centerpoint : Vector2 = { f32(settingsdata.windowWidth)/2, f32(settingsdata.windowHeight)/2 }
	topleft     : Vector2 = { centerpoint.x - (PAUSE_WIDTH/2), centerpoint.y - (PAUSE_HEIGHT/2) }

	//* Background
	DrawTextureNPatch(
		graphicsdata.box,
		graphicsdata.box_nPatch,
		{topleft.x, topleft.y, PAUSE_WIDTH, PAUSE_HEIGHT},
		{0,0}, 0,
		RAYWHITE,
	)

	//* Buttons
	resume := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-150,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		WHITE,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"RESUME",
	)
	save := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"SAVE",
	)
	load := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"LOAD",
	)
	options := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+0,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
	//	WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"OPTIONS",
	)
	quitmenu := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		//WHITE,
		GRAY,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"MENU",
	)
	quit := draw_button_new(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		graphicsdata.box,
		graphicsdata.box_nPatch,
		WHITE,
		GRAY,
		graphicsdata.font,
		16,
		BLACK,
		"QUIT",
	)

	//* Button logic
	if resume   do pausemenu = false
	if save     {} // TODO
	if load     {} // TODO
	if options  {} // TODO: do optionsmenu = true
	if quitmenu {
		// TODO: Unload game
		//titleScreen = true
		//pausemenu   = false
	}
	if quit     do abort = true
}