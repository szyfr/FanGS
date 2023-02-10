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
PAUSE_WIDTH  : f32 : 200
PAUSE_HEIGHT : f32 : 320
PAUSE_BUTTON_WIDTH  : f32 : 180
PAUSE_BUTTON_HEIGHT : f32 :  50


//= Procedures
draw_pausemenu :: proc() {
	centerpoint : raylib.Vector2 = { f32(game.settings.windowWidth)/2, f32(game.settings.windowHeight)/2 }
	topleft     : raylib.Vector2 = { centerpoint.x - (PAUSE_WIDTH/2), centerpoint.y - (PAUSE_HEIGHT/2) }

	//* Background
	raylib.DrawTextureNPatch(
		game.general_textbox,
		game.general_textbox_npatch,
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
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["resume"],
	)
	save := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["save"],
	)
	load := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y-50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		//raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["load_game"],
	)
	options := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+0,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["options"],
	)
	quitmenu := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+50,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["main_menu"],
	)
	quit := elements.draw_button(
		{
			centerpoint.x-(PAUSE_BUTTON_WIDTH/2),
			centerpoint.y+100,
			PAUSE_BUTTON_WIDTH, PAUSE_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["quit"],
	)

	//* Button logic
	if resume	do game.menu = .none
	if save		{} //TODO
	if load		{} //TODO
	if options	do game.menu = .options //TODO
	if quitmenu	{
		worldmap.close()
		game.state = .mainmenu
		game.menu  = .none
	}
	if quit		do game.abort = true
}