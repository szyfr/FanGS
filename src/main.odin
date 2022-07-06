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
			update_player_movement();
			update_elements(gui.elements);
		}

		// Drawing
		{
			raylib.begin_drawing();
				raylib.clear_background(raylib.RAYWHITE);

				if !gamestate.titleScreen {

					raylib.begin_mode3d(player.camera);
					raylib.draw_grid(100, 1);
					raylib.end_mode3d();

				} else {
					draw_elements(gui.elements);
				}

				raylib.draw_fps(0,0);

			raylib.end_drawing();
		}
	}

	raylib.close_window();
}


//= Initialization
main_initialization :: proc() {

	raylib.set_trace_log_level(i32(raylib.Trace_Log_Level.LOG_NONE));

	init_settings();
	init_localization();
	init_gamestate();
	init_player();

	raylib.init_window(settings.windowWidth, settings.windowHeight, "FanGS: Fantasy Grande Strategy");
	raylib.set_target_fps(settings.targetFPS);
	
	init_graphics();
	init_gui();

}
main_free :: proc() {

	raylib.close_window();

	free_settings();
	free_localization();
	free_graphics();
	free_gamestate();
	free_player();

	print_log();

}