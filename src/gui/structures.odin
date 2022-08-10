package gui


//= Imports
import "../raylib"


//= Structures
GuiData :: struct {
	elements    : [dynamic]Element,

	titleScreen : bool,

	selectedMap : string,

	abort       : bool,
}

Element :: struct {
	type:       ElementType,
	using rect: raylib.Rectangle,

	// All
	text:       [dynamic]cstring,
	font:       ^raylib.Font,
	fontSize:   f32,
	fontColor:  raylib.Color,
	halignment: HAlignment,
	valignment: VAlignment,

	// Button, Toggle, Tooltip, Window
	background:       ^raylib.Texture,
	backgroundNPatch: ^raylib.N_Patch_Info,
	backgroundColor:   raylib.Color,

	// Button, Toggle
	effect: proc(guidata : ^GuiData, index : i32),

	// Toggle
	// TODO: Customizable icon for inside toggle
	checked: bool,

	// Windows
	selections: [dynamic]Element,
}


//= Enumerations
ElementType :: enum {none, label, button, toggle, tooltip, window, }
HAlignment  :: enum { left, center, right, }
VAlignment  :: enum { top,  center, bottom, }


//= Procedures
default_proc :: proc(guidata : ^GuiData, index : i32) {}