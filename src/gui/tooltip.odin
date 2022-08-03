package gui


//= Imports
import "../raylib"

import "../graphics"
import "../settings"


//= Procedures

//* Create tooltip
create_tooltip :: proc{ create_tooltip_single, create_tooltip_dynamic, };
create_tooltip_single :: proc(
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
	) -> Element  {

	return create_tooltip_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor);
}
create_tooltip_dynamic :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
		background       : ^raylib.Texture={},
		backgroundNPatch : ^raylib.N_Patch_Info={},
		backgroundColor  :  raylib.Color=raylib.WHITE) -> Element  {

	return create_tooltip_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor);
}
create_tooltip_full :: proc(
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
		backgroundColor  :  raylib.Color=raylib.WHITE) -> Element {

	// General
	element: Element = {};
	element.type = .tooltip;

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

	return element;
}

//* Tooltip logic
update_tooltip :: proc(tooltip: ^Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();

	tooltip.x = mousePosition.x + 10;
	tooltip.y = mousePosition.y -  5;
}
draw_tooltip :: proc(tooltip: ^Element) {
	raylib.draw_texture_n_patch(
		tooltip.background^,
		tooltip.backgroundNPatch^,
		tooltip.rect,
		raylib.Vector2{0,0}, 0,
		tooltip.backgroundColor);

	size: f32 = 16;

	longestString: int = 0;
	for i:=0; i<len(tooltip.text); i+=1 do if longestString < len(tooltip.text[i]) do longestString = len(tooltip.text[i]);

	textPosition: raylib.Vector2;
	switch tooltip.halignment {
		case .left:   textPosition.x = tooltip.x; break;
		case .center: textPosition.x = ((tooltip.width / 2) + tooltip.x) - (((tooltip.fontSize * f32(longestString)) * 1.1) / 2); break;
		case .right:  textPosition.x = (tooltip.x + tooltip.width) - (tooltip.fontSize * f32(longestString)) * 1.1; break;
	}

	for i:=0; i<len(tooltip.text); i+=1 {
		switch tooltip.valignment {
			case .top:    textPosition.y = tooltip.y + (f32(i) * (tooltip.fontSize + tooltip.fontSize/2)); break;
			case .center: textPosition.y = ((tooltip.height / 2) + tooltip.y) - (((tooltip.fontSize * f32(len(tooltip.text))) * 1.1) / 2) + (f32(i) * (tooltip.fontSize + tooltip.fontSize/2)); break;
			case .bottom: textPosition.y = (tooltip.y + tooltip.height) - (tooltip.fontSize * f32(len(tooltip.text))) * 1.1; break;
		}

		raylib.draw_text_ex(
			tooltip.font^,
			tooltip.text[i],
			textPosition,
			tooltip.fontSize, 1,
			tooltip.fontColor);
	}
}