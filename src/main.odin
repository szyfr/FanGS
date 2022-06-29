package main



import "core:fmt"
import "core:strings"

import "raylib"


//= Main
main :: proc() {

	main_initialization();


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


//= Initialization
main_initialization :: proc() {
	
	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE));

	init_settings();

	raylib.init_window(settings.windowHeight, settings.windowWidth, "FanGS: Fantasy Grande Strategy");
	raylib.set_target_fps(settings.targetFPS);

}
main_free :: proc() {

	raylib.close_window();

	free_settings();

}