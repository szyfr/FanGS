package main



//= Imports
import "core:fmt"

import "raylib"


//= Constants

//= Global Variables
gui: ^Gui;


//= Structures
Gui :: struct {
	elements: [dynamic]Element,
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
	effect: proc(),

	// Toggle
	// TODO: Customizable icon for inside toggle
	checked: bool,

	// Windows
	selections: [dynamic]Element,
}


//= Enumerations
ElementType :: enum { none, label, button, toggle, tooltip, window, };
HAlignment  :: enum { left, center, right, };
VAlignment  :: enum { top,  center, bottom, };


//= Procedures
init_gui :: proc() {
	gui = new(Gui);

	// TEST ELEMENTS
	append(&gui.elements, create_label(  rectangle={10, 10,200, 50}, text="Label", fontColor=raylib.RED));
	append(&gui.elements, create_button( rectangle={10, 60,200, 50}, text="Button"));
	append(&gui.elements, create_toggle( rectangle={10,110,200, 50}, text="Toggle"));
	str: [dynamic]cstring;
	append(&str,"tooltip","Line2","Line3");
	append(&gui.elements, create_tooltip(rectangle={10,160,200,100}, text=str));

	win: Element = {};
	win.type = .window;
	win.x,      win.y     = 10,260;
	win.height, win.width = 150,200;
	append(&win.text,"window");
	win.background       = &graphics.box;
	win.backgroundNPatch = &graphics.box_nPatch;
	win.backgroundColor  = raylib.WHITE;

	append(&win.selections, create_button(rectangle={10,0,200,50}, text="Selection 1"));

	append(&gui.elements, win);
}
free_gui :: proc() {
	delete(gui.elements);
	free(gui);
}

update_elements :: proc(elements: [dynamic]Element) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .button:
				update_button(&elements[i]);
				break;
			case .toggle:
				update_toggle(&elements[i]);
				break;
			case .tooltip:
				update_tooltip(&elements[i]);
				break;
			case .window:
				update_window(&elements[i]);
				break;
		}
	}
}
draw_elements   :: proc(elements: [dynamic]Element) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .label:   draw_label(&elements[i]);   break;
			case .button:  draw_button(&elements[i]);  break;
			case .toggle:  draw_toggle(&elements[i]);  break;
			case .tooltip: draw_tooltip(&elements[i]); break;
			case .window:  draw_window(&elements[i]);  break;
		}
	}
}

// - Update
update_button  :: proc(button: ^Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();

	if test_bounds(mousePosition, button.rect) {
		button.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			button.effect();
		}
	} else {
		button.backgroundColor = raylib.WHITE;
	}
}
update_toggle  :: proc(toggle: ^Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();
	toggleRect: raylib.Rectangle = {toggle.x,toggle.y,toggle.height,toggle.height};

	if test_bounds(mousePosition, toggleRect) {
		toggle.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			fmt.printf("fuck")
			toggle.checked = !toggle.checked;
		}
	} else {
		toggle.backgroundColor = raylib.WHITE;
	}
}
update_tooltip :: proc(tooltip: ^Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();

	tooltip.x = mousePosition.x + 10;
	tooltip.y = mousePosition.y -  5;
}
update_window  :: proc(window: ^Element) {
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

	update_elements(window.selections);
}

// - Draw
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
draw_button  :: proc(button: ^Element) {
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
		case .left:   textPosition.x = button.x; break;
		case .center: textPosition.x = ((button.width / 2) + button.x) - (((button.fontSize * f32(longestString)) * 1.1) / 2); break;
		case .right:  textPosition.x = (button.x + button.width) - (button.fontSize * f32(longestString)) * 1.1; break;
	}
	switch button.valignment {
		case .top:    textPosition.y = button.y; break;
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
draw_toggle  :: proc(toggle: ^Element) {
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

	if toggle.checked do raylib.draw_text_ex(graphics.font, "X", {toggle.x+2.5, toggle.y+2.5}, toggle.height-5, 1, raylib.BLACK);
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
draw_window  :: proc(window: ^Element) {
	raylib.draw_texture_n_patch(
		graphics.box,
		graphics.box_nPatch,
		window.rect,
		raylib.Vector2{0,0}, 0,
		window.backgroundColor);

	size: f32 = 16;

	for i:=0; i<len(window.text); i+=1 {
		textPosition: raylib.Vector2 = {};
		textPosition.x = 16 + window.x;
		textPosition.y = 16 + window.y + (f32(i) * (16 + 10));

		raylib.draw_text_ex(graphics.font, window.text[i], textPosition, size, 1, raylib.BLACK);
	}

	draw_elements(window.selections);
}

// - Create Label
create_label :: proc{ create_label_single, create_label_dynamic, };
create_label_single :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center) -> Element  {

	return create_label_full(
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment);
}
create_label_dynamic :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center) -> Element {

	return create_label_full(
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment);
}
create_label_full :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		textsingle:           cstring=nil,
		textdynamic: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center) -> Element {

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
	if font == {}    do label.font = &graphics.font;
	else             do label.font = font;
	if fontSize == 0 do label.fontSize = settings.fontSize;
	else             do label.fontSize = fontSize;
	label.fontColor = fontColor;

	// Alignment
	label.halignment = halignment;
	label.valignment = valignment;

	return label;
}

// - Create Button
create_button :: proc{ create_button_single, create_button_dynamic, };
create_button_single :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: cstring="",
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc) -> Element  {

	return create_button_full(
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect);
}
create_button_dynamic :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc) -> Element  {

	return create_button_full(
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect);
}
create_button_full :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		textsingle:           cstring=nil,
		textdynamic: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment:       HAlignment=.center,
		valignment:       VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc) -> Element {

	// General
	element: Element = {};
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
	if font == {}    do element.font = &graphics.font;
	else             do element.font = font;
	if fontSize == 0 do element.fontSize = settings.fontSize;
	else             do element.fontSize = fontSize;
	element.fontColor = fontColor;

	// Alignment
	element.halignment = halignment;
	element.valignment = valignment;

	// Background
	if background == {}       do element.background = &graphics.box;
	else                      do element.background = background;
	if backgroundNPatch == {} do element.backgroundNPatch = &graphics.box_nPatch;
	else                      do element.backgroundNPatch = backgroundNPatch;
	element.backgroundColor = backgroundColor;

	// Procedure
	element.effect = effect;

	return element;
}

// - Create Toggle
create_toggle :: proc{ create_toggle_single, create_toggle_dynamic, };
create_toggle_single :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc,
		checked:          bool=false) -> Element  {

	return create_toggle_full(
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect, checked=checked);
}
create_toggle_dynamic :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc,
		checked:          bool=false) -> Element  {

	return create_toggle_full(
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor,
		effect=effect, checked=checked);
}
create_toggle_full :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		textsingle:           cstring=nil,
		textdynamic: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment:       HAlignment=.center,
		valignment:       VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE,
		effect:           proc()=default_proc,
		checked:          bool=false) -> Element {

	// General
	element: Element = {};
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
	if font == {}    do element.font = &graphics.font;
	else             do element.font = font;
	if fontSize == 0 do element.fontSize = settings.fontSize;
	else             do element.fontSize = fontSize;
	element.fontColor = fontColor;

	// Alignment
	element.halignment = halignment;
	element.valignment = valignment;

	// Background
	if background == {}       do element.background = &graphics.box;
	else                      do element.background = background;
	if backgroundNPatch == {} do element.backgroundNPatch = &graphics.box_nPatch;
	else                      do element.backgroundNPatch = backgroundNPatch;
	element.backgroundColor = backgroundColor;

	// Procedure
	element.effect = effect;

	// Checked
	element.checked = checked;

	return element;
}

// - Create Tooltip
// TODO: have creation function have default nil rectangle and have it instead calculate the needed size
create_tooltip :: proc{ create_tooltip_single, create_tooltip_dynamic, };
create_tooltip_single :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: cstring="",
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE) -> Element  {

	return create_tooltip_full(
		rectangle=rectangle, textsingle=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor);
}
create_tooltip_dynamic :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		text: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment: HAlignment=.center,
		valignment: VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE) -> Element  {

	return create_tooltip_full(
		rectangle=rectangle, textdynamic=text,
		font=font, fontSize=fontSize, fontColor=fontColor,
		halignment=halignment, valignment=valignment,
		background=background, backgroundNPatch=backgroundNPatch,
		backgroundColor=backgroundColor);
}
create_tooltip_full :: proc(
		rectangle: raylib.Rectangle={0,0,100,50},
		textsingle:           cstring=nil,
		textdynamic: [dynamic]cstring=nil,
		font: ^raylib.Font={}, fontSize: f32=0, fontColor: raylib.Color=raylib.BLACK,
		halignment:       HAlignment=.center,
		valignment:       VAlignment=.center,
		background:       ^raylib.Texture={},
		backgroundNPatch: ^raylib.N_Patch_Info={},
		backgroundColor:  raylib.Color=raylib.WHITE) -> Element {

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
	if font == {}    do element.font = &graphics.font;
	else             do element.font = font;
	if fontSize == 0 do element.fontSize = settings.fontSize;
	else             do element.fontSize = fontSize;
	element.fontColor = fontColor;

	// Alignment
	element.halignment = halignment;
	element.valignment = valignment;

	// Background
	if background == {}       do element.background = &graphics.box;
	else                      do element.background = background;
	if backgroundNPatch == {} do element.backgroundNPatch = &graphics.box_nPatch;
	else                      do element.backgroundNPatch = backgroundNPatch;
	element.backgroundColor = backgroundColor;

	return element;
}

// - Create Window



// - Default proc
default_proc :: proc() {}