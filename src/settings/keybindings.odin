package settings


//= Imports
import "core:os"

import "vendor:raylib"

import "../gamedata"
import "../logging"


//= Constants

//= Procedures

//* Checking if a key is pressed
is_key_down :: proc(key : string) -> bool {
	using gamedata, raylib

	//* Check for key's existance
	keybind, res := settingsdata.keybindings[key]
	if !res do logging.add_to_log("[ERROR]: Attepted to use unimplemented keybinding.")

	switch keybind.origin {
		case 0: // Keyboard
			return IsKeyDown(KeyboardKey(keybind.key))
		case 1: // Mouse
			return IsMouseButtonDown(MouseButton(keybind.key))
		case 2: // Gamepad Button
			return IsGamepadButtonDown(0, GamepadButton(keybind.key))
	}
	return false
}

// TODO:
//  - Pressed
//  - Released
//  - Up
//  - Axis