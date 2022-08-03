package gui


//= Imports
import "../raylib"

import "../graphics"
import "../settings"


//= Procedures

//* Create label
create_label :: proc{ create_label_single, create_label_dynamic, };
create_label_single :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
	) -> Element  {

	return create_label_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment);
}
create_label_dynamic :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		text             :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
	) -> Element {

	return create_label_full(
		graphicsdata=graphicsdata, settingsdata=settingsdata,
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment);
}
create_label_full :: proc(
		graphicsdata     : ^graphics.GraphicsData,
		settingsdata     : ^settings.SettingsData,
		rectangle        :  raylib.Rectangle={0,0,100,50},
		textsingle       :  cstring=nil,
		textdynamic      :  [dynamic]cstring=nil,
		font             : ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment       :  HAlignment=.center,
		valignment       :  VAlignment=.center,
	) -> Element {

	// General
	label: Element = {};
	label.type = .label;

	// Rectangle
	label.rect = rectangle;

	// Text
	if textsingle == "" && textdynamic == nil {
		strs: [dynamic]cstring;
		append(&strs, "NO INPUT");
		label.text = strs;
	} else {
		if textsingle != "" {
			strs: [dynamic]cstring;
			append(&strs, textsingle);
			label.text = strs;
		}
		if textdynamic != nil do label.text = textdynamic;
	}
	
	// Font / Font Size / Font Color
	if font == {}    do label.font = &graphicsdata.font;
	else             do label.font = font;
	if fontSize == 0 do label.fontSize = settingsdata.fontSize;
	else             do label.fontSize = fontSize;
	label.fontColor = fontColor;

	// Alignment
	label.halignment = halignment;
	label.valignment = valignment;

	return label;
}

//* Draw Label
draw_label   :: proc(label: ^Element) {
	size: f32 = 16;
	
	longestString: int = 0;
	for i:=0; i<len(label.text); i+=1 do if longestString < len(label.text[i]) do longestString = len(label.text[i]);

	textPosition: raylib.Vector2;
	switch label.halignment {
		case .left:   textPosition.x = label.x; break;
		case .center: textPosition.x = ((label.width / 2) + label.x) - (((label.fontSize * f32(longestString)) * 1.1) / 2); break;
		case .right:  textPosition.x = (label.x + label.width) - (label.fontSize * f32(longestString)) * 1.1; break;
	}
	switch label.valignment {
		case .top:    textPosition.y = label.y; break;
		case .center: textPosition.y = ((label.height / 2) + label.y) - (((label.fontSize * f32(len(label.text))) * 1.1) / 2); break;
		case .bottom: textPosition.y = (label.y + label.height) - (label.fontSize * f32(len(label.text))) * 1.1; break;
	}

	raylib.draw_text_ex(
		label.font^,
		label.text[0],
		textPosition,
		label.fontSize, 1,
		label.fontColor);
}