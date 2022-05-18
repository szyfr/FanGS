package main
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import rl "raylib"
import lc "core/localization"
import pl "core/player"
import wm "core/worldmap"
import ut "core/utilities"



// Initialization
init_main :: proc() {
	// Raylib initialization
	rl.set_trace_log_level(7);
	rl.init_window(screen_width, screen_height, "FanGS: Fantasy Grande Strategy");
	rl.set_target_fps(60);
	rl.set_exit_key(rl.Keyboard_Key.KEY_END);

	// Global initializations
	lc.init_localization();
	pl.init_player();
	wm.init_worldmap();
}