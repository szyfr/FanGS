package worldmap


//= Imports
import "core:fmt"
import "core:math/linalg"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../localization"
import "../gamedata"
import "../settings"
import "../utilities/colors"
import "../utilities/matrix_math"

//= Procedures
//* Generates border around image
apply_borders :: proc(
	image : ^raylib.Image,
) {
	using raylib, gamedata
	
	collect_points(image)
	collect_points(image)
}
apply_borders_old :: proc(
	image : ^raylib.Image,
) {
	using raylib, gamedata

	pixelCount := int(image.width * image.height)
	first      :  Vector2
	prev       :  Vector2

	//* Grab first point
	for i:=0;i<pixelCount;i+=1 {
		//* Grab color
		posX, posY := i32(i)%image.width, i32(i)/image.width
		col := GetImageColor(
			image^,
			posX, posY,
		)
		//* Compare
		if colors.compare_colors(WHITE, col) {
	fmt.printf("%v\n",col)
			//* Change color
			ImageDrawPixel(
				image,
				posX, posY,
				GRAY,
			)
			first = {f32(posX), f32(posY)}
			prev  = {f32(posX), f32(posY)}
			break
		}
	}

	//* Find next point
	current : Vector2   = {-1,-1}
	dir     : Direction = .right
	fmt.printf("Fuck ")

	for current != first {
		newPosition, newDirection := check_for_point(image, {prev.x, 0, prev.y}, dir)

		dir = newDirection

		current = {newPosition.x, newPosition.z}
		fmt.printf("Fuck Cur:%v Fir:%v\n",current,first)

		//* Append to array
		ImageDrawPixel(
			image,
			i32(newPosition.x), i32(newPosition.z),
			GRAY,
		)
		prev = {newPosition.x, newPosition.z}
	}
}


//*
collect_points :: proc(
	image    : ^raylib.Image,
) {
	using raylib, gamedata

	pixelCount := int(image.width * image.height)
	array : [dynamic]Vector2
	for i:=0;i<pixelCount;i+=1 {
		posX, posY := i32(i)%image.width, i32(i)/image.width
		col := GetImageColor(image^, posX, posY)

		if check_surrounding(image, {f32(posX),f32(posY)}) && col == WHITE {
			append(&array, Vector2{f32(posX),f32(posY)})
		}
	}
	for i:=0;i<len(array);i+=1 {
		ImageDrawPixel(	
			image,
			i32(array[i].x), i32(array[i].y),
			GRAY,
		)
	}
}

//*
check_surrounding :: proc(
	image    : ^raylib.Image,
	position :  raylib.Vector2,
) -> bool {
	using raylib, gamedata

	result : bool = false
	col    : raylib.Color

	//* Edge
	if position.y == 0                 do return true
	if position.y == f32(image.height) do return true
	if position.x == 0                 do return true
	if position.x == f32(image.width)  do return true

	//* Up
	col = GetImageColor(image^, i32(position.x), i32(position.y-1))
	if col != WHITE do return true
	//* Upright
	col = GetImageColor(image^, i32(position.x+1), i32(position.y-1))
	if col != WHITE do return true
	//* Right
	col = GetImageColor(image^, i32(position.x+1), i32(position.y))
	if col != WHITE do return true
	//* Downright
	col = GetImageColor(image^, i32(position.x+1), i32(position.y+1))
	if col != WHITE do return true
	//* Down
	col = GetImageColor(image^, i32(position.x), i32(position.y+1))
	if col != WHITE do return true
	//* Downleft
	col = GetImageColor(image^, i32(position.x-1), i32(position.y+1))
	if col != WHITE do return true
	//* Left
	col = GetImageColor(image^, i32(position.x-1), i32(position.y))
	if col != WHITE do return true
	//* Upleft
	col = GetImageColor(image^, i32(position.x-1), i32(position.y-1))
	if col != WHITE do return true

	return false
}

//* Clears province color to white
remove_colors :: proc(
	image : ^raylib.Image,
	color :  raylib.Color,
) {
	using raylib

	for i:=0;i<int(image.width*image.height);i+=1 {
		col := GetImageColor(
			image^,
			i32(i)%image.width, i32(i)/image.width,
		)
		if colors.compare_colors(color, col) {
			ImageDrawPixel(
				image,
				i32(i)%image.width, i32(i)/image.width,
				WHITE,
			)
		}
	}
}

//* Generates an alpha mask
generate_alpha_mask :: proc(
	image : ^raylib.Image,
	color : raylib.Color,
) -> raylib.Image {
	using raylib

	img := ImageCopy(image^)

	for i:=0;i<int(image.width*image.height);i+=1 {
		col := GetImageColor(
			img,
			i32(i)%img.width, i32(i)/img.width,
		)
		if colors.compare_colors(color, col) {
			ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{255,255,255,255},
			)
		} else {
			ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{0,0,0,0},
			)
		}
	}

	return img
}

pixel_offset :: proc(
	dir : gamedata.Direction,
) -> raylib.Vector3 {
	newPosition : raylib.Vector3
	mod : f32 = .0125

	switch dir {
		case .right:
			newPosition.z += mod
		case .downright:
			newPosition.x += mod
			newPosition.z += mod
		case .down:
			newPosition.x -= mod
		case .downleft:
			newPosition.x -= mod
			newPosition.z -= mod
		case .left:
			newPosition.z -= mod
		case .upleft:
			newPosition.x += mod
			newPosition.z -= mod
		case .up:
			newPosition.x += mod
		case .upright:
			newPosition.x += mod
			newPosition.z += mod
	}

	return newPosition
}

//* Checks for same colored point around starting point
check_for_point :: proc(
	image : ^raylib.Image,
	pos   :  raylib.Vector3,
	dir   :  gamedata.Direction,
) -> (raylib.Vector3, gamedata.Direction) {
	using raylib, gamedata

	//* Declare variables
	newDirection := get_new_direction(dir)
	newPosition  : Vector3

	for i:=0;i<len(Direction);i+=1 {
		//* Calculate new position and check against edge of map
		newPosition  = get_direction_position(pos,newDirection)
		if newPosition.x > f32(image.width)  do continue
		if newPosition.z > f32(image.height) do continue
		
		//* Grab color and compare
		newColor := GetImageColor(
			image^,
			i32(newPosition.x), i32(newPosition.z),
		)
		if colors.compare_colors(WHITE, newColor) do break
		if colors.compare_colors(GRAY, newColor) do break

		//* Set new direction and loop
		newDirection = increment_direction(newDirection)
	}

	return newPosition, newDirection
}

//* Returns point offset by direction
get_direction_position :: proc(
	position  : raylib.Vector3,
	direction : gamedata.Direction,
) -> raylib.Vector3 {
	newPosition := position
	switch direction {
		case .right:
			newPosition.x +=1
		case .downright:
			newPosition.x +=1
			newPosition.z +=1
		case .down:
			newPosition.z +=1
		case .downleft:
			newPosition.x -=1
			newPosition.z +=1
		case .left:
			newPosition.x -=1
		case .upleft:
			newPosition.x -=1
			newPosition.z -=1
		case .up:
			newPosition.z -=1
		case .upright:
			newPosition.x +=1
			newPosition.z -=1
	}

	return newPosition
}

//* Returns direction perpendicular to the current direction
get_new_direction :: proc(
	dir : gamedata.Direction,
) -> gamedata.Direction {
	newDirection : gamedata.Direction

	switch dir {
		case .right:
			newDirection = .up
		case .downright:
			newDirection = .upright
		case .down:
			newDirection = .right
		case .downleft:
			newDirection = .downright
		case .left:
			newDirection = .down
		case .upleft:
			newDirection = .downleft
		case .up:
			newDirection = .left
		case .upright:
			newDirection = .upleft
	}

	return newDirection
}

//* Increments direction and loops it
increment_direction :: proc(
	dir : gamedata.Direction,
) -> gamedata.Direction {
	newDirection := gamedata.Direction(int(dir) + 1)
	if newDirection > .upright do newDirection = .right

	return newDirection
}

//* Checks the surrounding pixels if they are the same color and returns
check_pixel :: proc(
	color : raylib.Color,
	x, y  : i32,
) -> bool {
	using raylib, gamedata

	empty : u8 = 0

	if !colors.compare_colors(color, GetImageColor(worlddata.provinceImage,   x, y-1)) do empty+=1
	if !colors.compare_colors(color, GetImageColor(worlddata.provinceImage,   x, y+1)) do empty+=1
	if !colors.compare_colors(color, GetImageColor(worlddata.provinceImage, x-1,   y)) do empty+=1
	if !colors.compare_colors(color, GetImageColor(worlddata.provinceImage, x+1,   y)) do empty+=1

	if empty >= 1 do return true
	return false
}