package main



//= Imports
import "core:fmt"

import "raylib"

//= Constants

//= Global Variables

//= Structures

//= Enumerations

//= Procedures

//fuse   :: proc{ fuse_i32, fuse_keybind, }
//unfuse :: proc{ unfuse_i32 }

// - Fuse bytes into larger data type
fuse_i32     :: proc(array: []u8, offset: u32) -> i32 {
	return (i32(array[offset+3]) << 24) | (i32(array[offset+2]) << 16) | (i32(array[offset+1]) << 8) | i32(array[offset]);
}
fuse_keybind :: proc(array: []u8, offset: u32) -> Keybinding {
	key: Keybinding = {};

	key.origin = array[offset+3];
	key.key    = (u32(array[offset+1]) << 8) | u32(array[offset]);

	return key;
}

// Seperate larger datatypes into bytes
unfuse_i32 :: proc(var: i32, array: []u8) {
	array[0] = u8(var);
	array[1] = u8(var >> 8);
	array[2] = u8(var >> 16);
	array[3] = u8(var >> 24);
}
unfuse_keybind :: proc(var: Keybinding, array: []u8) {
	array[0] = u8(var.key);
	array[1] = u8(var.key >> 8);
	array[2] = 0;
	array[3] = var.origin;
}

// Bounds testing
test_bounds :: proc(pos: raylib.Vector2, bounds: raylib.Rectangle) -> bool {
	result: bool = false;

	result = (pos.x >= bounds.x) & (pos.x <= bounds.x + bounds.width) & (pos.y >= bounds.y) & (pos.y <= bounds.y + bounds.height);

	return result;
}