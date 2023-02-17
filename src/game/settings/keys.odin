package settings


//= Imports
import "core:os"

import "vendor:raylib"

import "../../game"

import "../../debug"


//= Constants
ERR_KEYBINDING_ATTEMPT :: "[ERROR]:\tAttepted to use unimplemented keybinding."


//= Procedures

//* Key is held down
is_key_down :: proc(
	key : string,
) -> bool {

	//* Check for key's existance
	keybind, res := game.settings.keybindings[key]
	if !res do debug.create(&game.errorHolder.errorArray, ERR_KEYBINDING_ATTEMPT, 2)

	switch keybind.origin {
		case 0: // Keyboard
			return raylib.IsKeyDown(raylib.KeyboardKey(keybind.key))
		case 1: // Mouse
			return raylib.IsMouseButtonDown(raylib.MouseButton(keybind.key))
		case 2: // Scrollwheel
		case 3: // Gamepad Button
			return raylib.IsGamepadButtonDown(0, raylib.GamepadButton(keybind.key))
	}
	return false
	
}

//* Key is pressed once
is_key_pressed :: proc(
	key : string,
) -> bool {

	//* Check for key's existance
	keybind, res := game.settings.keybindings[key]
	if !res do debug.create(&game.errorHolder.errorArray, ERR_KEYBINDING_ATTEMPT, 2)

	switch keybind.origin {
		case 0: // Keyboard
			return raylib.IsKeyPressed(raylib.KeyboardKey(keybind.key))
		case 1: // Mouse
			return raylib.IsMouseButtonPressed(raylib.MouseButton(keybind.key))
		case 2: // Scrollwheel
			if keybind.key == 0 && raylib.GetMouseWheelMove() > 0 do return true
			if keybind.key == 1 && raylib.GetMouseWheelMove() < 0 do return true
		case 3: // Gamepad Button
			return raylib.IsGamepadButtonPressed(0, raylib.GamepadButton(keybind.key))
	}
	return false

}

is_mapmode_pressed :: proc() -> (bool, game.Mapmode) {
	if is_key_pressed("mm01") do return true, game.settings.mapmodesTool[1]
	if is_key_pressed("mm02") do return true, game.settings.mapmodesTool[2]
	if is_key_pressed("mm03") do return true, game.settings.mapmodesTool[3]
	if is_key_pressed("mm04") do return true, game.settings.mapmodesTool[4]
	if is_key_pressed("mm05") do return true, game.settings.mapmodesTool[5]
	if is_key_pressed("mm06") do return true, game.settings.mapmodesTool[6]
	if is_key_pressed("mm07") do return true, game.settings.mapmodesTool[7]
	if is_key_pressed("mm08") do return true, game.settings.mapmodesTool[8]
	if is_key_pressed("mm09") do return true, game.settings.mapmodesTool[9]
	if is_key_pressed("mm00") do return true, game.settings.mapmodesTool[0]

	return false, .overworld
}