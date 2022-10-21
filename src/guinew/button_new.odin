package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_button_new :: proc(
	transform  : raylib.Rectangle,
	bg         : raylib.Texture,
	bgnpatch   : raylib.NPatchInfo,
	bgcolor    : raylib.Color,
	bgcolorsel : raylib.Color,
	font       : raylib.Font,
	fontSize   : f32,
	fontColor  : raylib.Color,
	text       : cstring,
) -> bool {
	bgcolorcurr   := bgcolor
	mousePosition := raylib.GetMousePosition()
	
	//* Testing if Hovered or clicked
	if test_bounds(mousePosition, transform) {
		bgcolorcurr = bgcolorsel
		if raylib.IsMouseButtonReleased(.LEFT) do return true
	} else do bgcolorcurr = bgcolor

	//* Drawing background
	raylib.DrawTextureNPatch(
		bg, bgnpatch,
		transform,
		{0,0}, 0,
		bgcolorcurr,
	)

	//* Calculating text position
	textPosition : raylib.Vector2
	textPosition.x = ((transform.width / 2) + transform.x) - (((fontSize * f32(len(text))) * 1.1) / 2);
	textPosition.y = ((transform.height / 2) + transform.y) - (((fontSize * 1) * 1.1) / 2)

	//* Drawing text
	raylib.DrawTextEx(
		font, text,
		textPosition,
		fontSize, 1,
		fontColor,
	)

	return false
}