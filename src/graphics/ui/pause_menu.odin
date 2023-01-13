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
PAUSE_WIDTH  : f32 : 200
PAUSE_HEIGHT : f32 : 320
PAUSE_BUTTON_WIDTH  : f32 : 180
PAUSE_BUTTON_HEIGHT : f32 :  50


//= Procedures
draw_pausemenu :: proc() {
	centerpoint : raylib.Vector2 = { f32(settings.data.windowWidth)/2, f32(settings.data.windowHeight)/2 }
	topleft     : raylib.Vector2 = { centerpoint.x - (PAUSE_WIDTH/2), centerpoint.y - (PAUSE_HEIGHT/2) }

	//* Background
	raylib.DrawTextureNPatch(
		graphics.general_textbox,
		graphics.general_textbox_npatch,
		{topleft.x, topleft.y, PAUSE_WIDTH, PAUSE_HEIGHT},
		{0,0}, 0,
		raylib.RAYWHITE,
	)

	//* Buttons
	resume := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-150,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["resume"],
	)
	save := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["save"],
	)
	load := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["load_game"],
	)
	options := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+0,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["options"],
	)
	quitmenu := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["main_menu"],
	)
	quit := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["quit"],
	)

	//* Button logic
	// TODO: Save, Load, and Options screens and functionality
	if resume   do game.pauseMenu = false
	if save     {}
	if load     {}
	if options  {} // do optionsmenu = true
	if quitmenu {
		// TODO: Unload game
		//titleScreen = true
		//pausemenu   = false
	}
	if quit     do game.abort = true
}