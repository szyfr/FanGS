package guinew


//= Imports
import "../raylib"

import "../gamedata"


//= Procedures
create_label :: proc(
	position  :  raylib.Vector2 = {0, 0},
	font      : ^raylib.Font    = nil,
	fontSize  :  f32            = 0,
	fontColor :  raylib.Color   = raylib.BLACK,
	text      : ^cstring        = nil,
) -> int {
	label := new(gamedata.Label)

	label.type      = .label
	label.position  =  position
	label.fontColor =  fontColor
	
	if font == nil   do label.font     = &gamedata.graphicsdata.font
	else             do label.font     =  font
	if fontSize == 0 do label.fontSize =  gamedata.settingsdata.fontSize
	else             do label.fontSize =  fontSize
	if text == nil   do label.text     = &gamedata.localizationdata.missing
	else             do label.text     =  text

	append(&gamedata.elements, rawptr(label))

	return len(gamedata.elements) - 1
}

draw_label :: proc(label : ^gamedata.Label) {
	raylib.draw_text_ex(
		label.font^,
		label.text^,
		label.position,
		label.fontSize, 1,
		label.fontColor,
	)
}