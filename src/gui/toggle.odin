package gui


//= Imports
import "core:fmt"

import "../raylib"

import "../gamedata"
import "../graphics"
import "../settings"


//= Procedures

//* Create toggle
create_toggle :: proc{ create_toggle_single, create_toggle_dynamic, };
create_toggle_single :: proc(
		graphicsdata     : ^gamedata.GraphicsData,
		settingsdata     : ^gamedata.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  gamedata.HAlignment=.center,
		valignment       :  gamedata.VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		effect           :  proc(guidata : ^gamedata.GuiData, index : i32)=gamedata.default_proc,
		checked          :  bool=false,
	) -> gamedata.Element  {

	return create_toggle_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect, checked=checked);
}
create_toggle_dynamic :: proc(
		graphicsdata     : ^gamedata.GraphicsData,
		settingsdata     : ^gamedata.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  gamedata.HAlignment=.center,
		valignment       :  gamedata.VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		effect           :  proc(guidata : ^gamedata.GuiData, index : i32)=gamedata.default_proc,
		checked          :  bool=false,
	) -> gamedata.Element  {

	return create_toggle_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect, checked=checked);
}
create_toggle_full :: proc(
		graphicsdata     : ^gamedata.GraphicsData,
		settingsdata     : ^gamedata.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		textsingle       :  cstring=nil,
		textdynamic      :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  gamedata.HAlignment=.center,
		valignment       :  gamedata.VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		effect           :  proc(guidata : ^gamedata.GuiData, index : i32)=gamedata.default_proc,
		checked          :  bool=false,
	) -> gamedata.Element {

	// General
	element: gamedata.Element = {};
	element.type = .toggle;

	// Rectangle
	element.rect = rectangle;

	// Text
	if textsingle == "" && textdynamic == nil {
		strs: [dynamic]cstring;
		append(&strs, "NO INPUT");
		element.text = strs;
	} else {
		if textsingle != "" {
			strs: [dynamic]cstring;
			append(&strs, textsingle);
			element.text = strs;
		}
		if textdynamic != nil do element.text = textdynamic;
	}
	
	// Font / Font Size / Font Color
	if font == {}    do element.font = &graphicsdata.font;
	else             do element.font = font;
	if fontSize == 0 do element.fontSize = settingsdata.fontSize;
	else             do element.fontSize = fontSize;
	element.fontColor = fontColor;

	// Alignment
	element.halignment = halignment;
	element.valignment = valignment;

	// Background
	if background == {}       do element.background = &graphicsdata.box;
	else                      do element.background = background;
	if backgroundNPatch == {} do element.backgroundNPatch = &graphicsdata.box_nPatch;
	else                      do element.backgroundNPatch = backgroundNPatch;
	element.backgroundColor = backgroundColor;

	// Procedure
	element.effect = effect;

	// Checked
	element.checked = checked;

	return element;
}

//* Toggle logic
update_toggle  :: proc(toggle: ^gamedata.Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();
	toggleRect: raylib.Rectangle = {toggle.x,toggle.y,toggle.height,toggle.height};

	if test_bounds(mousePosition, toggleRect) {
		toggle.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			toggle.checked = !toggle.checked;
		}
	} else {
		toggle.backgroundColor = raylib.WHITE;
	}
}
draw_toggle  :: proc(toggle: ^gamedata.Element) {
	toggleRect: raylib.Rectangle = {toggle.x,toggle.y,toggle.height,toggle.height};

	raylib.draw_texture_n_patch(
		toggle.background^,
		toggle.backgroundNPatch^,
		toggleRect,
		raylib.Vector2{0,0}, 0,
		toggle.backgroundColor);

	size: f32 = 16;

	longestString: int = 0;
	for i:=0; i<len(toggle.text); i+=1 do if longestString < len(toggle.text[i]) do longestString = len(toggle.text[i]);

	textPosition: raylib.Vector2;
	switch toggle.halignment {
		case .left:   textPosition.x = (toggle.x + toggleRect.width); break;
		case .center: textPosition.x = (((toggle.width - toggleRect.width) / 2) + (toggle.x + toggleRect.width)) - (((toggle.fontSize * f32(longestString)) * 1.1) / 2); break;
		case .right:  textPosition.x = (toggle.x + toggle.width) - (toggle.fontSize * f32(longestString)) * 1.1; break;
	}
	switch toggle.valignment {
		case .top:    textPosition.y = toggle.y; break;
		case .center: textPosition.y = ((toggle.height / 2) + toggle.y) - (((toggle.fontSize * f32(len(toggle.text))) * 1.1) / 2); break;
		case .bottom: textPosition.y = (toggle.y + toggle.height) - (toggle.fontSize * f32(len(toggle.text))) * 1.1; break;
	}
	
	raylib.draw_text_ex(
		toggle.font^,
		toggle.text[0],
		textPosition,
		toggle.fontSize, 1,
		toggle.fontColor);

	if toggle.checked do raylib.draw_text_ex(toggle.font^, "X", {toggle.x+2.5, toggle.y+2.5}, toggle.height-5, 1, raylib.BLACK);
}