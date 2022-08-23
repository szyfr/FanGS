package guinew


//= Imports
import "vendor:raylib"

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

	id := generate_id()
	gamedata.elements[id] = rawptr(label)

	return id
}

draw_label :: proc(label : ^gamedata.Label) {
	raylib.DrawTextEx(
		label.font^,
		label.text^,
		label.position,
		label.fontSize, 1,
		label.fontColor,
	)
}