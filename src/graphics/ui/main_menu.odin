package ui


//= Imports
import "core:fmt"
import "vendor:raylib"

import "elements"
import "../worldmap"
import "../../game"
import "../../game/settings"
import "../../game/localization"


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
	centerpoint : raylib.Vector2 = { 0, f32(game.settings.windowHeight)/2 }
	topleft     : raylib.Vector2 = { 0, 0 }

	//* Drawing title
	raylib.DrawTextEx(
		game.font,
		game.localization["game_name"],
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
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["new_game"],
	)
	load := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y-25,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
	//	raylib.WHITE,
		raylib.GRAY,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["load_game"],
	)
	mods := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+50,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
		},
		&game.general_textbox,
		&game.general_textbox_npatch,
		raylib.WHITE,
		raylib.GRAY,
		&game.font,
		game.settings.fontSize,
		raylib.BLACK,
		&game.localization["mods"],
	)
	options := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+125,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
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
	quit := elements.draw_button(
		{
			centerpoint.x+25,
			centerpoint.y+200,
			MAIN_BUTTON_WIDTH, MAIN_BUTTON_HEIGHT,
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
	// TODO: Load, Mods, and Options screens and functionality
	if new		{
		//TODO Show error on screen if NO mods enabled
		game.menu  = .none
		game.state = .choose
		worldmap.init("farophi") //TODO New mod loader
		if game.modsDirectory != nil do raylib.ClearDirectoryFiles()
	}
	if load		{}
	if mods		do game.menu = .mods
	if options	do game.menu = .options
	if quit		do return 1

	return 0
}