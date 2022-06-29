package main



//= Imports

//= Constants

//= Global Variables

//= Structures

//= Enumerations

//= Procedures

fuse :: proc{ fuse_i32 }

fuse_i32 :: proc(array: [^]u8, offset: u32) -> i32 {
	return (i32(array[offset+3]) << 24) | (i32(array[offset+2]) << 16) | (i32(array[offset+1]) << 8) | i32(array[offset]);
}
