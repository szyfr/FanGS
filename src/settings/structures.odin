package settings


//= Imports

//= Constants
SETTINGS_FILE_SIZE :: 0x0040


//= Structures
SettingsData :: struct {
	windowWidth:   i32,
	windowHeight:  i32,

	targetFPS:     i32,

	language:      Languages,

	edgeScrolling: bool,

	fontSize:      f32,

	keybindings:   map[string]Keybinding,
}
Keybinding :: struct {
	origin: u8,
	key:    u32,
}


//= Enumerations
Languages   :: enum i32 {
	english = 0,
	spanish,
	german,
	french,
}