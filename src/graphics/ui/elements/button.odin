package elements


//= Imports
import "vendor:raylib"


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
	bgColor : raylib.Color = bgColorDefault
	result  : bool         = false

	//* Test if clicked
	mousePosition := raylib.GetMousePosition()
	
	if test_bounds(mousePosition, transform) {
		bgColor = bgColorSelected
		if raylib.IsMouseButtonReleased(.LEFT) do result = true
	}

	raylib.DrawTextureNPatch(
		background^,
		backgroundNPatch^,
		transform,
		raylib.Vector2{0,0}, 0,
		bgColor,
	)

	textPosition : raylib.Vector2
	textPosition.x = ((transform.width / 2) + transform.x) - (((fontSize * f32(len(text))) * 1.1) / 2);
	textPosition.y = ((transform.height / 2) + transform.y) - (((fontSize * 1) * 1.1) / 2)

	raylib.DrawTextEx(
		font^,
		text^,
		textPosition,
		fontSize, 1,
		fontColor,
	)

	return result
}