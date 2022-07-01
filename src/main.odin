package main



import "core:fmt"
import "core:strings"

import "raylib"


//= Main
main :: proc() {

	main_initialization();

	add_to_log("[MAJOR]: Fuck");
	add_to_log("fuck");
	add_to_log("fuck");
	add_to_log("fuck");
	print_log();


	for !raylib.window_should_close() {
		// Updating
		{
			update_player_movement();
		}

		// Drawing
		{
			raylib.begin_drawing();
				raylib.clear_background(raylib.RAYWHITE);

				raylib.begin_mode3d(player.camera);
					raylib.draw_grid(100, 1);
				raylib.end_mode3d();

			raylib.end_drawing();
		}
	}

	raylib.close_window();
}


//= Initialization
main_initialization :: proc() {

	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE));

	init_settings();
	init_player();
	init_localization();

	raylib.init_window(settings.windowHeight, settings.windowWidth, "FanGS: Fantasy Grande Strategy");
	raylib.set_target_fps(settings.targetFPS);

}
main_free :: proc() {

	raylib.close_window();

	free_settings();
	free_player();
	free_localization();

}