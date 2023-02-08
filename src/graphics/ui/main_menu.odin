package ui


//= Imports
import "core:fmt"
import "vendor:raylib"

import "elements"
import "../worldmap"
import "../../game"
import "../../game/settings"
import "../../game/localization"
import "../../graphics"


//= Constants
MAIN_WIDTH         : f32 : 200
MAIN_HEIGHT        : f32 : 320
MAIN_BUTTON_WIDTH  : f32 : 250
MAIN_BUTTON_HEIGHT : f32 :  60

out_quit     :: 1
out_newgame  :: 2
out_loadgame :: 3
out_options  :: 4
out_mods     :: 5


//= Procedures
draw_mainmenu :: proc() -> i32 {
	centerpoint : raylib.Vector2 = { 0, f32(settings.data.windowHeight)/2 }
	topleft     : raylib.Vector2 = { 0, 0 }

	//* Drawing title
	raylib.DrawTextEx(
		graphics.font,
		localization.data["game_name"],
		topleft + 50,
		40, 1,
		raylib.BLACK,
	)

	//* Drawing buttons
	new := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y-100,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["new_game"],
	)
	load := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y-25,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
	//	raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["load_game"],
	)
	mods := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+50,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
	//	raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["mods"],
	)
	options := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+125,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&graphics.general_textbox,
		&graphics.general_textbox_npatch,
	//	raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&graphics.font,
		settings.data.fontSize,
		raylib.BLACK,
		&localization.data["options"],
	)
	quit := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+200,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
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
	// TODO: Load, Mods, and Options screens and functionality
	if new {
		game.state = .choose
		worldmap.init("farophi")
	}
	if load    {}
	if mods    {}
	if options {} // do optionsmenu = true
	if quit    do return 1

	return 0
}