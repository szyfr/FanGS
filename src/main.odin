package main



import "core:fmt"
import "core:strings"

import "raylib"


/// Main
main :: proc() {

	for !raylib.window_should_close() {
		// Updating
		{
			
		}

		// Drawing
		{
			raylib.begin_drawing();
				raylib.clear_background(raylib.RAYWHITE);
			raylib.end_drawing();
		}
	}

	raylib.close_window();
}
