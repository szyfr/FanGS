package gui


//= Imports
import "core:fmt"

import "../raylib"

import "../gamedata"
import "../graphics"
import "../settings"


//= Procedures

//* Create button
create_button :: proc{ create_button_single, create_button_dynamic, };
create_button_single :: proc(
		graphicsdata     : ^gamedata.GraphicsData,
		settingsdata     : ^gamedata.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  cstring="",
		font             : ^raylib.Font={},
		fontSize         :  f32=0,
		fontColor        :  raylib.Color=raylib.BLACK,
		halignment       :  gamedata.HAlignment=.center,
		valignment       :  gamedata.VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE,
		effect           :  proc(guidata : ^gamedata.GuiData, index : i32)=gamedata.default_proc,
	) -> gamedata.Element  {

	return create_button_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect);
}
create_button_dynamic :: proc(
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
	) -> gamedata.Element  {

	return create_button_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect);
}
create_button_full :: proc(
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
	) -> gamedata.Element {

	// General
	element: gamedata.Element = {};
	element.type = .button;

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

	return element;
}

//* Button logic
update_button  :: proc{ update_main_button, update_sub_button, }
update_main_button  :: proc(guidata: ^gamedata.GuiData, index : i32) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();
	button : ^gamedata.Element = &guidata.elements[index]

	if test_bounds(mousePosition, button.rect) {
		button.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			button.effect(guidata, index);
		}
	} else {
		button.backgroundColor = raylib.WHITE;
	}
}
update_sub_button  :: proc(button: ^gamedata.Element, guidata : ^gamedata.GuiData, owner : i32) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();

	if test_bounds(mousePosition, button.rect) {
		button.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			button.effect(guidata, owner);
		}
	} else {
		button.backgroundColor = raylib.WHITE;
	}
}
draw_button  :: proc(button: ^gamedata.Element) {
	raylib.draw_texture_n_patch(
		button.background^,
		button.backgroundNPatch^,
		button.rect,
		raylib.Vector2{0,0}, 0,
		button.backgroundColor);

	size: f32 = 16;
	
	longestString: int = 0;
	for i:=0; i<len(button.text); i+=1 do if longestString < len(button.text[i]) do longestString = len(button.text[i]);

	textPosition: raylib.Vector2;
	switch button.halignment {
		case .left:   textPosition.x = button.x + 16; break;
		case .center: textPosition.x = ((button.width / 2) + button.x) - (((button.fontSize * f32(longestString)) * 1.1) / 2); break;
		case .right:  textPosition.x = (button.x + button.width) - (button.fontSize * f32(longestString)) * 1.1; break;
	}
	switch button.valignment {
		case .top:    textPosition.y = button.y + 16; break;
		case .center: textPosition.y = ((button.height / 2) + button.y) - (((button.fontSize * f32(len(button.text))) * 1.1) / 2); break;
		case .bottom: textPosition.y = (button.y + button.height) - (button.fontSize * f32(len(button.text))) * 1.1; break;
	}

	raylib.draw_text_ex(
		button.font^,
		button.text[0],
		textPosition,
		button.fontSize, 1,
		button.fontColor);
}