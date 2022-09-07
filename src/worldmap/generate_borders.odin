package worldmap


//= Imports
import "core:fmt"
import "vendor:raylib"

import "../gamedata"


//= Procedures
generate_borders :: proc(
	color : raylib.Color,
) -> [dynamic]gamedata.Point {
	using raylib, gamedata

	pixelCount := int(gamedata.mapdata.provinceImage.width * gamedata.mapdata.provinceImage.height)
	array :  [dynamic]Point
	prev  : ^Point

	//TODO:
	// - Starting perpindicular to the current direction it checks adjacent pixels for the same color
	// - If it finds the same color it moves and saves the direction it went and repeats the same step
	// - If the new direction is the same as the old direction it doesn't save the new point until
	//   it either gets the the pixel in the direction its going or it finds a new point before the direction

	point : Point = {}

	//* Searching for first point
	for i:=0;i<pixelCount;i+=1 {
		posX, posY := i32(i)%gamedata.mapdata.provinceImage.width, i32(i)/gamedata.mapdata.provinceImage.width
		col := GetImageColor(gamedata.mapdata.provinceImage, posX, posY)
		
		if compare_colors(color, col) {
			point.x, point.y = f32(posX), f32(posY)
			break
		}
	}
	

//	for i:=0;i<pixelCount;i+=1 {
//		posX, posY := i32(i)%gamedata.mapdata.provinceImage.width, i32(i)/gamedata.mapdata.provinceImage.width
//		point : Point = {}
//		col := GetImageColor(
//			gamedata.mapdata.provinceImage,
//			posX, posY,
//		)
//		if compare_colors(color, col) && check_pixel(color, posX, posY) {
//			point.x, point.z = f32(posX/250), f32(posY/250)
//			point.y = 5
//
//			if prev != nil do point.next = prev
//			
//		//	if point.next != nil do fmt.printf(
//		//		"Point\npos: %v,%v,%v\nnex: %v,%v,%v\n\n",
//		//		point.x, point.y, point.z,
//		//		point.next.x, point.next.y, point.next.z,
//		//	)
//
//			append(&array, point)
//			prev = &array[len(array)-1]
//		}
//	}
//	array[0].next = &array[len(array)-1]

	return array
}

//TODO: Move
check_for_point :: proc(
	color : raylib.Color,
	pos   : raylib.Vector3,
	dir   : gamedata.Direction,
) -> (raylib.Vector3, gamedata.Direction) {
	using raylib, gamedata


}

//TODO: Move
check_pixel :: proc(
	color : raylib.Color,
	x, y  : i32,
) -> bool {
	using raylib, gamedata

	empty : u8 = 0

	if !compare_colors(color, GetImageColor(gamedata.mapdata.provinceImage,   x, y-1)) do empty+=1
	if !compare_colors(color, GetImageColor(gamedata.mapdata.provinceImage,   x, y+1)) do empty+=1
	if !compare_colors(color, GetImageColor(gamedata.mapdata.provinceImage, x-1,   y)) do empty+=1
	if !compare_colors(color, GetImageColor(gamedata.mapdata.provinceImage, x+1,   y)) do empty+=1

	if empty >= 1 do return true
	return false
}

//TODO: Move
compare_colors :: proc(
	col1,col2 : raylib.Color,
) -> bool {
	result : bool = true

	if col1.r != col2.r do result = false
	if col1.g != col2.g do result = false
	if col1.b != col2.b do result = false

	return result
}