package worldmap


//= Imports
import "core:fmt"
import "vendor:raylib"

import "../gamedata"


//= Procedures
//TODO: After finished check all pixels of the same color if they are inside border
//      If not, they may be an island and create a new border for it.
generate_borders :: proc(
	color : raylib.Color,
) -> [dynamic]gamedata.Point {
	using raylib, gamedata

	pixelCount := int(gamedata.mapdata.provinceImage.width * gamedata.mapdata.provinceImage.height)
	array :  [dynamic]Point
	prev  : ^Point
	loc   :  Vector3

	for i:=0;i<pixelCount;i+=1 {
		posX, posY := i32(i)%gamedata.mapdata.provinceImage.width, i32(i)/gamedata.mapdata.provinceImage.width
		col := GetImageColor(
			gamedata.mapdata.provinceImage,
			posX, posY,
		)
		if compare_colors(color, col) {
			point := Point{
				0,
				{f32(posX), -1, f32(posY)},
			}
			append(&array, point)
			prev  = &array[0]
			break
		}
	}

	point  : Point
	dir    : Direction = .right
	previd : int = 0
	for point.pos != array[0].pos {
		newPosition, newDirection := check_for_point(color, prev.pos, dir)

		point.pos    = newPosition
		point.idNext = previd

	//	fmt.printf(
	//		"Positions: 0(%v,%v,%v) ? C(%v,%v,%v) ? P(%v,%v,%v)\n",
	//		array[0].x,array[0].y,array[0].z,
	//		point.x,point.y,point.z,
	//		point.next.x,point.next.y,point.next.z,
	//	)

	//	if dir == newDirection do continue

		dir = newDirection

		append(&array, point)
		prev = &array[len(array)-1]
		previd += 1
	}
	array[0].idNext = len(array)-2

	return array
}

//TODO: Move
check_for_point :: proc(
	color : raylib.Color,
	pos   : raylib.Vector3,
	dir   : gamedata.Direction,
) -> (raylib.Vector3, gamedata.Direction) {
	using raylib, gamedata

	//* Declare variables
	newDirection := get_new_direction(dir)
	newPosition  : Vector3

	for i:=0;i<len(Direction);i+=1 {
		//* Calculate new position and check against edge of map
		newPosition  = get_direction_position(pos,newDirection)
		if newPosition.x > f32(gamedata.mapdata.provinceImage.width)  do continue
		if newPosition.z > f32(gamedata.mapdata.provinceImage.height) do continue
		
		//* Grab color and compare
		newColor    := GetImageColor(
			gamedata.mapdata.provinceImage,
			i32(newPosition.x), i32(newPosition.z),
		)
		if compare_colors(color, newColor) do break

		//* Set new direction and loop
		newDirection = increment_direction(newDirection)
	}

	return newPosition, newDirection
}

//TODO: Move
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

//TODO: Move
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

//TODO: Move
increment_direction :: proc(
	dir : gamedata.Direction,
) -> gamedata.Direction {
	newDirection := gamedata.Direction(int(dir) + 1)
	if newDirection > .upright do newDirection = .right

	return newDirection
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