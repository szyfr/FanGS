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
		case 2: // Scrollwheel
		case 3: // Gamepad Button
			return IsGamepadButtonDown(0, GamepadButton(keybind.key))
	}
	return false
}

is_key_pressed :: proc(key : string) -> bool {
	using gamedata, raylib

	//* Check for key's existance
	keybind, res := settingsdata.keybindings[key]
	if !res do logging.add_to_log("[ERROR]: Attepted to use unimplemented keybinding.")

	switch keybind.origin {
		case 0: // Keyboard
			return IsKeyPressed(KeyboardKey(keybind.key))
		case 1: // Mouse
			return IsMouseButtonPressed(MouseButton(keybind.key))
		case 2: // Scrollwheel
			if keybind.key == 0 && GetMouseWheelMove() > 0 do return true
			if keybind.key == 1 && GetMouseWheelMove() < 0 do return true
		case 3: // Gamepad Button
			return IsGamepadButtonPressed(0, GamepadButton(keybind.key))
	}
	return false
}

// TODO:
//  - Released
//  - Up
//  - Axis