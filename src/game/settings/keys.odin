package settings


//= Imports
import "core:os"
import "vendor:raylib"
import "../../debug"


//= Constants
ERR_KEYBINDING_ATTEMPT :: "[ERROR]:\tAttepted to use unimplemented keybinding."


//= Procedures

//* Key is held down
is_key_down :: proc(
	key : string,
) -> bool {

	//* Check for key's existance
	keybind, res := data.keybindings[key]
	if !res do debug.add_to_log(ERR_KEYBINDING_ATTEMPT)

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
	keybind, res := data.keybindings[key]
	if !res do debug.add_to_log(ERR_KEYBINDING_ATTEMPT)

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