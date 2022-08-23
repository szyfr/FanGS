package gamedata


//= Imports
import "vendor:raylib"


//= Structures
Label  :: struct {
	type           :  GuiElementType,
	using position :  raylib.Vector2,

	font           : ^raylib.Font,
	fontSize       :  f32,
	fontColor      :  raylib.Color,

	text           : ^cstring,
}
Button :: struct {
	type             :  GuiElementType,
	using transform  :  raylib.Rectangle,

	background       : ^raylib.Texture,
	backgroundNPatch : ^raylib.NPatchInfo,
	
	bgColorDefault   :  raylib.Color,
	bgColorSelected  :  raylib.Color,
	bgColorCurrent   :  raylib.Color,

	font             : ^raylib.Font,
	fontSize         :  f32,
	fontColor        :  raylib.Color,

	text             : ^cstring,

	effect           :  proc(),
}


//= Enumerations
GuiElementType :: enum { none, label, button, toggle, tooltip, window, }