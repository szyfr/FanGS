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
	font:       ^raylib.Font,      //TODO:
	fontSize:   f32,               //TODO:
	alignement: u8,                //TODO:
	offset:     raylib.Vector2,    //TODO:
	textColor:  raylib.Color,      //TODO:

	// Button, Toggle, Tooltip, Window
	background:       ^raylib.Texture,
	backgroundNPatch: ^raylib.N_Patch_Info,
	backgroundColor:   raylib.Color,        //TODO:

	// Button, Toggle
	effect: proc(),

	// Toggle
	checked: bool,

	// Windows
	selections: [dynamic]Element,
}


//= Enumerations
ElementType :: enum { none, label, button, toggle, tooltip, window, };


//= Procedures
init_gui :: proc() {
	gui = new(Gui);

	lab: Element = {};
	lab.type = .label;
	lab.x,      lab.y     = 10,10;
	lab.height, lab.width = 50,200;
	append(&lab.text,"label");

	but: Element = {};
	but.type = .button;
	but.x,      but.y     = 10,60;
	but.height, but.width = 50,200;
	append(&but.text,"button");
	but.background       = &graphics.box;
	but.backgroundNPatch = &graphics.box_nPatch;
	but.backgroundColor  = raylib.WHITE;

	tog: Element = {};
	tog.type = .toggle;
	tog.x,      tog.y     = 10,110;
	tog.height, tog.width = 50,200;
	append(&tog.text,"toggle");
	tog.background       = &graphics.box;
	tog.backgroundNPatch = &graphics.box_nPatch;
	tog.backgroundColor  = raylib.WHITE;

	tot: Element = {};
	tot.type = .tooltip;
	tot.x,      tot.y     = 10,160;
	tot.height, tot.width = 100,200;
	append(&tot.text,"tooltip","Line2","Line3");
	tot.background       = &graphics.box;
	tot.backgroundNPatch = &graphics.box_nPatch;
	tot.backgroundColor  = raylib.WHITE;

	win: Element = {};
	win.type = .window;
	win.x,      win.y     = 10,260;
	win.height, win.width = 150,200;
	append(&win.text,"window");
	win.background       = &graphics.box;
	win.backgroundNPatch = &graphics.box_nPatch;
	win.backgroundColor  = raylib.WHITE;

	winEle: Element = {};
	winEle.type = .button;
	winEle.x,      winEle.y     = 10,360;
	winEle.height, winEle.width = 50,200;
	append(&winEle.text,"button");
	winEle.background       = &graphics.box;
	winEle.backgroundNPatch = &graphics.box_nPatch;
	winEle.backgroundColor     = raylib.WHITE;

	append(&win.selections,winEle);

	append(&gui.elements, lab, but, tog, tot, win);
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
draw_elements :: proc(elements: [dynamic]Element) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .label:
				draw_label(&elements[i]);
				break;
			case .button:
				draw_button(&elements[i]);
				break;
			case .toggle:
				draw_toggle(&elements[i]);
				break;
			case .tooltip:
				draw_tooltip(&elements[i]);
				break;
			case .window:
				draw_window(&elements[i]);
				break;
		}
	}
}

// - Update
update_button :: proc(button: ^Element) {
	mousePosition: raylib.Vector2 = raylib.get_mouse_position();

	if test_bounds(mousePosition, button.rect) {
		button.backgroundColor = raylib.GRAY;

		if raylib.is_mouse_button_released(.MOUSE_BUTTON_LEFT) {
			fmt.printf("fuck")
		}
	} else {
		button.backgroundColor = raylib.WHITE;
	}
}
update_toggle :: proc(toggle: ^Element) {
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
update_window :: proc(window: ^Element) {
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
draw_label :: proc(label: ^Element) {
	size: f32 = 16;

	textPosition: raylib.Vector2;
	textPosition.x = ((f32(label.width) / 2) - ((size * f32(len(label.text[0]))) / 2)) + label.x;
	textPosition.y = ((f32(label.height) / 2) - size/2) + label.y;

	raylib.draw_text_ex(
		graphics.font,
		label.text[0],
		textPosition,
		size, 1,
		raylib.BLACK);
}
draw_button :: proc(button: ^Element) {
	raylib.draw_texture_n_patch(
		graphics.box,
		graphics.box_nPatch,
		button.rect,
		raylib.Vector2{0,0}, 0,
		button.backgroundColor);

	size: f32 = 16;

	textPosition: raylib.Vector2;
	textPosition.x = ((f32(button.width) / 2) - ((size * f32(len(button.text[0]))) / 2)) + button.x;
	textPosition.y = ((f32(button.height) / 2) - size/2) + button.y;

	raylib.draw_text_ex(graphics.font, button.text[0], textPosition, size, 1, raylib.BLACK);
}
draw_toggle :: proc(toggle: ^Element) {
	toggleRect: raylib.Rectangle = {toggle.x,toggle.y,toggle.height,toggle.height};

	raylib.draw_texture_n_patch(
		graphics.box,
		graphics.box_nPatch,
		toggleRect,
		raylib.Vector2{0,0}, 0,
		toggle.backgroundColor);

	size: f32 = 16;

	textPosition: raylib.Vector2;
	textPosition.x = ((f32(toggleRect.width + toggle.width) / 2) - ((size * f32(len(toggle.text[0]))) / 2)) + toggle.x;
	textPosition.y = ((f32(toggle.height) / 2) - size/2) + toggle.y;

	raylib.draw_text_ex(graphics.font, toggle.text[0], textPosition, size, 1, raylib.BLACK);

	if toggle.checked do raylib.draw_text_ex(graphics.font, "X", {toggle.x+2.5, toggle.y+2.5}, toggle.height-5, 1, raylib.BLACK);
}
draw_tooltip :: proc(tooltip: ^Element) {
	raylib.draw_texture_n_patch(
		graphics.box,
		graphics.box_nPatch,
		tooltip.rect,
		raylib.Vector2{0,0}, 0,
		tooltip.backgroundColor);

	size: f32 = 16;

	for i:=0; i<len(tooltip.text); i+=1 {
		textPosition: raylib.Vector2 = {};
		textPosition.x = 16 + tooltip.x;
		textPosition.y = 16 + tooltip.y + (f32(i) * (16 + 10));

		raylib.draw_text_ex(graphics.font, tooltip.text[i], textPosition, size, 1, raylib.BLACK);
	}
}
draw_window :: proc(window: ^Element) {
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