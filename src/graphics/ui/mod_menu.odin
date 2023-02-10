package ui


//= Imports
import "core:strings"

import "vendor:raylib"

import "elements"
import "../../game"


//= Constants
MOD_PATH			:: "data/mods"

MOD_REFRESH_WIDTH	:: 200
MOD_REFRESH_HEIGHT	::  50
MOD_ENABLE_WIDTH	:: 150


MOD_WIDTH			: f32 : 200
MOD_HEIGHT			: f32 : 320
MOD_BUTTON_WIDTH	: f32 : 180
MOD_BUTTON_HEIGHT	: f32 :  50


//= Procedures
draw_modmenu :: proc() {
	centerpoint	: raylib.Vector2 = { f32(game.settings.windowWidth)/2, f32(game.settings.windowHeight)/2 }
	topleft		: raylib.Vector2 = { centerpoint.x/2, centerpoint.y/2 }
	botright	: raylib.Vector2 = { centerpoint.x + (centerpoint.x/2), centerpoint.y + (centerpoint.y/2) }

	elementWidth	: f32 = f32(game.settings.windowWidth) / 2
	elementHeight	: f32 = f32(game.settings.windowHeight) / 2

	if len(game.modsDirectory) == 0 do load_mod_directories()

	//* BG
	raylib.DrawTextureNPatch(
		game.general_textbox,
		game.general_textbox_npatch,
		{ topleft.x, topleft.y, elementWidth, elementHeight },
		{0,0}, 0,
		raylib.RAYWHITE,
	)

	//* Titles
	raylib.DrawTextEx(
		game.font,
		game.localization["mod_name"],
		{ topleft.x + 40, topleft.y + 25},
		game.settings.fontSize+4, 1,
		raylib.BLACK,
	)
	raylib.DrawTextEx(
		game.font,
		game.localization["mod_enable"],
		{ botright.x - (f32(len(game.localization["mod_enable"])) * (game.settings.fontSize+4)) - 70, topleft.y + 25},
		game.settings.fontSize+4, 1,
		raylib.BLACK,
	)

	//* Mods
	for i:=0;i<len(game.modsDirectory);i+=1 {
		raylib.DrawTextEx(
			game.font,
			game.modsDirectory[i],
			{ topleft.x+25, topleft.y + 60 + (25*f32(i)) },
			game.settings.fontSize, 1,
			raylib.BLACK,
		)
		//TODO Enable button
		result := false
		for m:=0;m<len(game.mods);m+=1 {
			if game.mods[m] == game.modsDirectory[i] do result = true
		}

		str := &game.localization["mod_disabled"]
		if result do str = &game.localization["mod_enabled"]
		col1 : raylib.Color = { 255, 100, 100, 255 }
		col2 : raylib.Color = { 255,   0,   0, 255 }
		if result {
			col1 = raylib.GREEN
			col2 = raylib.DARKGREEN
		}
		enable := elements.draw_button(
			transform			= { botright.x - MOD_ENABLE_WIDTH - 50, topleft.y + 55 + (25*f32(i)), MOD_ENABLE_WIDTH, game.settings.fontSize * 2 },
			background			= &game.general_textbox,
			backgroundNPatch	= &game.general_textbox_npatch,
			font				= &game.font,
			fontSize			=  game.settings.fontSize,
			bgColorDefault		=  col1,
			bgColorSelected		=  col2,
			text				=  str,
		)

		if enable {
			if result	do disable_mod(game.modsDirectory[i])
			else		do enable_mod(game.modsDirectory[i])
		}
	}

	//* Refresh button
	refresh := elements.draw_button(
		transform			= { botright.x - MOD_REFRESH_WIDTH, botright.y - MOD_REFRESH_HEIGHT, MOD_REFRESH_WIDTH, MOD_REFRESH_HEIGHT },
		background			= &game.general_textbox,
		backgroundNPatch	= &game.general_textbox_npatch,
		font				= &game.font,
		fontSize			=  game.settings.fontSize+4,
		text				= &game.localization["mod_refresh"],
	)

	if refresh do load_mod_directories()
}

load_mod_directories :: proc() {
	for c in game.modsDirectory do delete(c)
	delete(game.modsDirectory)
	game.modsDirectory = make([dynamic]cstring)

	directoryCount	: i32 = 0
	modsDirect		:= raylib.GetDirectoryFiles(MOD_PATH, &directoryCount)

	for i:=2;i<int(directoryCount);i+=1 {
		str := strings.clone_from_cstring(modsDirect[i])
		append(&game.modsDirectory, strings.clone_to_cstring(str))
	}
	raylib.ClearDirectoryFiles()
}

enable_mod :: proc(
	name : cstring,
) {
	append(&game.mods, name)
}
disable_mod :: proc(
	name : cstring,
) {
	new := make([dynamic]cstring)

	for str in game.mods {
		if str != name do append(&new, str)
	}
	delete(game.mods)
	game.mods = new
}