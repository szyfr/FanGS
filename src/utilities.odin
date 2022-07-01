package main



//= Imports
import "core:fmt"

//= Constants

//= Global Variables

//= Structures

//= Enumerations

//= Procedures

fuse   :: proc{ fuse_i32 }
unfuse :: proc{ unfuse_i32 }

fuse_i32 :: proc(array: [^]u8, offset: u32) -> i32 {
	return (i32(array[offset+3]) << 24) | (i32(array[offset+2]) << 16) | (i32(array[offset+1]) << 8) | i32(array[offset]);
}

unfuse_i32 :: proc(var: i32, array: []u8) {

	array[0] = u8(var);
	array[1] = u8(var >> 8);
	array[2] = u8(var >> 16);
	array[3] = u8(var >> 24);
	
}