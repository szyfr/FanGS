package settings


//= Imports
import "core:encoding/json"

import "../../game"

import "../../debug"


//= Procedures
create_keybinding :: proc(
	obj : json.Object,
) -> game.Keybinding {

	binding : game.Keybinding = {}
	origin  :=  u8(obj[SETTINGS_ORIGIN].(f64))
	key     := u32(obj[SETTINGS_KEY].(f64))

	binding.key = key
	if origin < 4 {
		binding.origin = origin
		binding.valid  = true
	} else {
		binding.valid = false
		debug.add_to_log(ERR_SETTINGS_ORIG)
	}

	return binding
}