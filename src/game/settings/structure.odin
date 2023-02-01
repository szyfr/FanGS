package settings


//= Imports


//= Global
data : ^SettingsData


//= Structures
SettingsData :: struct {
	windowWidth   : i32,
	windowHeight  : i32,

	targetFPS     : i32,
	language      : cstring,
	edgeScrolling : bool,
	fontSize      : f32,

	keybindings   : map[string]Keybinding,
	mapmodesTool  : [10]Mapmode,
}

Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
}

Mapmode :: enum {
	overworld,
	political,
	terrain,
	control,
	population,
	ancestry,
	culture,
	religion,
}