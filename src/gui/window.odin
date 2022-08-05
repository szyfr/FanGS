package gui


//= Imports
import "../raylib"

import "../graphics"
import "../settings"


//= Procedures

//* Create window
create_window :: proc{ create_window_single, create_window_dynamic, }
create_window_single :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  cstring="",
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		selections       :  [dynamic]Element=nil,
) -> Element {

	return create_window_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		selections=selections)
}
create_window_dynamic :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		selections       :  [dynamic]Element=nil,
) -> Element {

	return create_window_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		selections=selections)
}
create_window_full :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		textsingle       :  cstring=nil,
		textdynamic      :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		selections       :  [dynamic]Element=nil,
	) -> Element {
	
	//* General
	window : Element = {}
	window.type = .window

	//* Rectangle
	window.rect = rectangle

	//* Text
	if textsingle == "" && textdynamic == nil {
		strs: [dynamic]cstring
		append(&strs, "NO INPUT")
		window.text = strs
	} else {
		if textsingle != "" {
			strs: [dynamic]cstring
			append(&strs, textsingle)
			window.text = strs
		}
		if textdynamic != nil do window.text = textdynamic
	}

	//* Font / Font Size / Font Color
	if font == {}    do window.font = &graphicsdata.font
	else             do window.font = font
	if fontSize == 0 do window.fontSize = settingsdata.fontSize
	else             do window.fontSize = fontSize
	window.fontColor = fontColor

	//* Alignment
	window.halignment = halignment;
	window.valignment = valignment;

	//* Background
	if background == {}       do window.background = &graphicsdata.box;
	else                      do window.background = background;
	if backgroundNPatch == {} do window.backgroundNPatch = &graphicsdata.box_nPatch;
	else                      do window.backgroundNPatch = backgroundNPatch;
	window.backgroundColor = backgroundColor;

	//* Selections
	if selections == nil {
		rect : raylib.Rectangle = {window.x + 5, window.y + window.height-55, window.width - 10, 50}
		append(&window.selections, create_button(
			graphicsdata=graphicsdata,
			settingsdata=settingsdata,
			rectangle=rect,
			text="OK",
			effect=close_window_proc,
		))
	}

	return window
}

//* Window logic
update_window  :: proc(window: ^Element, guidata : ^GuiData, index : i32) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();
	mouseDelta:    raylib.Vector2 = raylib.get_mouse_delta();

	if test_bounds(mousePosition, window.rect) && raylib.is_mouse_button_down(.MOUSE_BUTTON_LEFT) {
		window.x += mouseDelta.x;
		window.y += mouseDelta.y;

		for i:=0; i<len(window.selections); i+=1 {
			window.selections[i].x += mouseDelta.x;
			window.selections[i].y += mouseDelta.y;
		}
	}

	update_elements(window.selections, guidata, index);
}
draw_window  :: proc(window: ^Element) {
	raylib.draw_texture_n_patch(
		window.background^,
		window.backgroundNPatch^,
		window.rect,
		raylib.Vector2{0,0}, 0,
		window.backgroundColor);

	size: f32 = 16;

	for i:=0; i<len(window.text); i+=1 {
		textPosition: raylib.Vector2 = {};
		textPosition.x = 16 + window.x;
		textPosition.y = 16 + window.y + (f32(i) * (16 + 10));

		raylib.draw_text_ex(window.font^, window.text[i], textPosition, size, 1, raylib.BLACK);
	}

	draw_elements(window.selections);
}

//* Close window
close_window_proc :: proc(guidata : ^GuiData, index : i32) {
	delete_element(guidata,index)
}