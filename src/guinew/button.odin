package guinew


//= Imports
import "../raylib"

import "../gamedata"


//= Procedures
create_button :: proc(
	transform        :  raylib.Rectangle    = {0, 0, 100, 100},
	background       : ^raylib.Texture      = nil,
	backgroundNPatch : ^raylib.N_Patch_Info = nil,
	bgColorDefault   :  raylib.Color        = raylib.WHITE,
	bgColorSelected  :  raylib.Color        = raylib.GRAY,
	font             : ^raylib.Font         = nil,
	fontSize         :  f32                 = 0,
	fontColor        :  raylib.Color        = raylib.BLACK,
	text             : ^cstring             = nil,
	effect           :  proc()              = nil,
) -> int {
	button := new(gamedata.Button)

	button.type            = .button
	button.transform       =  transform
	button.bgColorCurrent  =  bgColorDefault
	button.bgColorDefault  =  bgColorDefault
	button.bgColorSelected =  bgColorSelected
	button.fontColor       =  fontColor
	button.effect          =  effect
	
	if background == nil       do button.background       = &gamedata.graphicsdata.box
	else                       do button.background       =  background
	if backgroundNPatch == nil do button.backgroundNPatch = &gamedata.graphicsdata.box_nPatch
	else                       do button.backgroundNPatch =  backgroundNPatch
	if font == nil             do button.font             = &gamedata.graphicsdata.font
	else                       do button.font             =  font
	if fontSize == 0           do button.fontSize         =  gamedata.settingsdata.fontSize
	else                       do button.fontSize         =  fontSize
	if text == nil             do button.text             = &gamedata.localizationdata.missing
	else                       do button.text             =  text

	append(&gamedata.elements, rawptr(button))

	return len(gamedata.elements) - 1
}

update_button :: proc(button : ^gamedata.Button) {
	mousePosition := raylib.get_mouse_position()
	
	if test_bounds(mousePosition, button) {
		button.bgColorCurrent = button.bgColorSelected
		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) && button.effect != nil do button.effect()
	} else do button.bgColorCurrent = button.bgColorDefault
}

draw_button :: proc(button : ^gamedata.Button) {
	raylib.draw_texture_n_patch(
		button.background^,
		button.backgroundNPatch^,
		button.transform,
		raylib.Vector2{0,0}, 0,
		button.bgColorCurrent,
	)

	textPosition : raylib.Vector2
	textPosition.x = ((button.width / 2) + button.x) - (((button.fontSize * f32(len(button.text))) * 1.1) / 2);
	textPosition.y = ((button.height / 2) + button.y) - (((button.fontSize * 1) * 1.1) / 2)

	raylib.draw_text_ex(
		button.font^,
		button.text^,
		textPosition,
		button.fontSize, 1,
		button.fontColor,
	)
}