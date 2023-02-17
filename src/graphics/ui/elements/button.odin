package elements


//= Imports
import "vendor:raylib"

import "../../../game"


//= Procedures

draw_button :: proc(
	transform        :  raylib.Rectangle  = {0, 0, 100, 100},
	background       : ^raylib.Texture    = nil,
	backgroundNPatch : ^raylib.NPatchInfo = nil,
	bgColorDefault   :  raylib.Color      = raylib.WHITE,
	bgColorSelected  :  raylib.Color      = raylib.GRAY,
	font             : ^raylib.Font       = nil,
	fontSize         :  f32               = 0,
	fontColor        :  raylib.Color      = raylib.BLACK,
	text             : ^cstring           = nil,
) -> bool {
	bgTexture		:= background
	bgNPatch		:= backgroundNPatch
	bgColor			:= bgColorDefault
	usedFont		:= font
	usedFontSize	:= fontSize
	str				: cstring = ""
	result			:= false

	if bgTexture == nil do bgTexture = &game.general_textbox
	if bgNPatch  == nil do bgNPatch  = &game.general_textbox_npatch
	if usedFont  == nil do usedFont  = &game.font
	if usedFontSize == 0 do usedFontSize = game.settings.fontSize
	if text != nil do str = text^

	//* Test if clicked
	mousePosition := raylib.GetMousePosition()
	if test_bounds(mousePosition, transform) {
		bgColor = bgColorSelected
		if raylib.IsMouseButtonReleased(.LEFT) do result = true
	}

	raylib.DrawTextureNPatch(
		bgTexture^,
		bgNPatch^,
		transform,
		raylib.Vector2{0,0}, 0,
		bgColor,
	)

	textPosition : raylib.Vector2
	textPosition.x = ((transform.width / 2) + transform.x) - (((fontSize * f32(len(str))) * 1.1) / 2);
	textPosition.y = ((transform.height / 2) + transform.y) - (((fontSize * 1) * 1.1) / 2)
	raylib.DrawTextEx(
		usedFont^,
		str,
		textPosition,
		usedFontSize, 1,
		fontColor,
	)

	return result
}