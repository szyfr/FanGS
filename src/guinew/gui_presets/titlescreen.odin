package gui_presets


//= Imports
import "../gui_effects"
import "../../gamedata"
import "../../guinew"


//= Procedures
create_titlescreen :: proc() {
	using gamedata
	
	titleScreen = true

	// Title
	guinew.create_label(
		position = {40,40},
		fontSize =  40,
		text     = &localizationdata.title,
	)
	// Menu
	guinew.create_button(
		transform = {10, 300, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.newGame,
		effect    =  gui_effects.start_new_game,
	)
	guinew.create_button(
		transform = {10, 360, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.loadGame,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 420, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.mods,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 480, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.options,
	//	effect    =  gui_effects.load_game,
	)
	guinew.create_button(
		transform = {10, 540, 250, 50},
		fontSize  =  20,
		text      = &localizationdata.quit,
		effect    =  gui_effects.quit_game,
	)
}