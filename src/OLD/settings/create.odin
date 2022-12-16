package settings


//= Imports
import "core:encoding/json"

import "../gamedata"


//= Procedures
create_keybinding :: proc(
	obj : json.Object,
) -> gamedata.Keybinding {
	keybind : gamedata.Keybinding = {
		u8(obj["origin"].(f64)),
		u32(obj["key"].(f64)),
	}

	return keybind
}