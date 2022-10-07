package gamedata


//= Imports

//= Structures
SettingsData :: struct {
	windowWidth   : i32,
	windowHeight  : i32,

	targetFPS     : i32,
	language      : Languages,
	edgeScrolling : bool,
	fontSize      : f32,

	keybindings   : map[string]Keybinding,
}
Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - Gamepad Button
		// 3 - Gamepad Axis
	key    : u32,
}


//= Enumerations
Languages   :: enum i32 {
	english = 0,
	spanish,
	german,
	french,
}