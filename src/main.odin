package main
///=-------------------=///
//  Written: 2022/05/11  //
//  Edited:  2022/05/11  //
///=-------------------=///



import "core:fmt"
import "core:strings"

import rl "raylib"
import lc "core/localization"
import pl "core/player"
import wm "core/worldmap"
import ut "core/utilities"


/// Main
main :: proc() {

	init_main();


	for !rl.window_should_close() {
		// Updating
		{
			pl.update_player_camera_movement();

			if rl.is_key_pressed(rl.Keyboard_Key.KEY_O) {
				fmt.printf("Pos: %f,%f,%f\n",
					pl.player_user.camera.position.x,
					pl.player_user.camera.position.y,
					pl.player_user.camera.position.z);
				fmt.printf("Tar: %f,%f,%f\n",
					pl.player_user.camera.target.x,
					pl.player_user.camera.target.y,
					pl.player_user.camera.target.z);
			}
		}

		// Drawing
		{
			rl.begin_drawing();
				rl.clear_background(rl.RAYWHITE);

				rl.begin_mode3d(pl.player_user.camera);
					rl.draw_grid(100, 1);
					rl.draw_cube(
						position = rl.Vector3{0, 0, 0},
						width    = 2,
						height   = 2,
						length   = 2,
						color    = rl.BLACK);
				rl.end_mode3d();

				str: strings.Builder = {};
				fmt.sbprintf(&str, "Pos: %f,%f,%f\nTar: %f,%f,%f",
					pl.player_user.camera.position.x, pl.player_user.camera.position.y, pl.player_user.camera.position.z,
					pl.player_user.camera.target.x,   pl.player_user.camera.target.y,   pl.player_user.camera.target.z);

				rl.draw_text(strings.clone_to_cstring(strings.to_string(str)), 0, 0, 20, rl.DARKGRAY);
			rl.end_drawing();
		}
	}

	rl.close_window();
}
