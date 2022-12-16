package settings


//= Imports
import "core:encoding/json"


//= Procedures
create_keybinding :: proc(
	obj : json.Object,
) -> Keybinding { //TODO output error
	return {
		u8(obj["origin"].(f64)), //TODO check for invalid members
		u32(obj["key"].(f64)),   //TODO check for invalid members
	}
}