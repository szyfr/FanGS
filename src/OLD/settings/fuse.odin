package settings


//= Imports
import "../gamedata"


//= Procedures

//* Fuse bytes into larger data type
fuse_i32     :: proc(array: []u8, offset: u32) -> i32 {
	return (i32(array[offset+3]) << 24) | (i32(array[offset+2]) << 16) | (i32(array[offset+1]) << 8) | i32(array[offset])
}
fuse_i16     :: proc(array: []u8, offset: u32) -> i16 {
	return (i16(array[offset+1]) << 8) | i16(array[offset])
}
fuse_keybind :: proc(array: []u8, offset: u32) -> gamedata.Keybinding {
	key: gamedata.Keybinding = {}

	key.origin = array[offset+3]
	key.key    = (u32(array[offset+1]) << 8) | u32(array[offset])

	return key
}

//* Seperate larger datatypes into bytes
unfuse_i32 :: proc(var: i32, array: []u8) {
	array[0] = u8(var)
	array[1] = u8(var >> 8)
	array[2] = u8(var >> 16)
	array[3] = u8(var >> 24)
}
unfuse_keybind :: proc(var: gamedata.Keybinding, array: []u8) {
	array[0] = u8(var.key)
	array[1] = u8(var.key >> 8)
	array[2] = 0
	array[3] = var.origin
}