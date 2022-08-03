package gui


//= Imports
import "../raylib"

import "../graphics"
import "../settings"


//= Procedures

//* Create window

//* Window logic
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