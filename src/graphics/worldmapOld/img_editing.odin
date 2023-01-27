package worldmap


//= Import
import "vendor:raylib"

import "../../utilities/colors"


//= Constants
BORDER_SIZE :: 1


//= Procedures
//TODO Go through and comment everything
//* Generates an alpha mask
generate_alpha_mask :: proc(
	image : ^raylib.Image,
	color : raylib.Color,
) -> raylib.Image {
	img := raylib.ImageCopy(image^)

	for i:=0;i<int(image.width*image.height);i+=1 {
		col := raylib.GetImageColor(
			img,
			i32(i)%img.width, i32(i)/img.width,
		)
		if colors.compare_colors(color, col) {
			raylib.ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{255,255,255,255},
			)
		} else {
			raylib.ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{0,0,0,0},
			)
		}
	}

	return img
}

//* Generates border around image
apply_borders :: proc(
	image : ^raylib.Image,
) {
	for i:=0;i<BORDER_SIZE;i+=1 do collect_points(image)
}

//* Clears province color to white
remove_colors :: proc(
	image : ^raylib.Image,
	color :  raylib.Color,
) {
	for i:=0;i<int(image.width*image.height);i+=1 {
		col := raylib.GetImageColor(
			image^,
			i32(i)%image.width, i32(i)/image.width,
		)
		if colors.compare_colors(color, col) {
			raylib.ImageDrawPixel(
				image,
				i32(i)%image.width, i32(i)/image.width,
				raylib.WHITE,
			)
		}
	}
}

//* ??
collect_points :: proc(
	image    : ^raylib.Image,
) {
	pixelCount := int(image.width * image.height)
	array : [dynamic]raylib.Vector2
	for i:=0;i<pixelCount;i+=1 {
		posX, posY := i32(i)%image.width, i32(i)/image.width
		col := raylib.GetImageColor(image^, posX, posY)

		if check_surrounding(image, {f32(posX),f32(posY)}) && col == raylib.WHITE {
			append(&array, raylib.Vector2{f32(posX),f32(posY)})
		}
	}
	for i:=0;i<len(array);i+=1 {
		raylib.ImageDrawPixel(	
			image,
			i32(array[i].x), i32(array[i].y),
			raylib.GRAY,
		)
	}
}

//* Checks if there is a pixel of the same color adjacent
check_surrounding :: proc(
	image    : ^raylib.Image,
	position :  raylib.Vector2,
) -> bool {
	result : bool = false
	col    : raylib.Color

	//* Edge
	if position.y == 0                 do return true
	if position.y == f32(image.height) do return true
	if position.x == 0                 do return true
	if position.x == f32(image.width)  do return true

	//* Up
	col = raylib.GetImageColor(image^, i32(position.x), i32(position.y-1))
	if col != raylib.WHITE do return true
	//* Upright
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y-1))
	if col != raylib.WHITE do return true
	//* Right
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y))
	if col != raylib.WHITE do return true
	//* Downright
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Down
	col = raylib.GetImageColor(image^, i32(position.x), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Downleft
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Left
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y))
	if col != raylib.WHITE do return true
	//* Upleft
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y-1))
	if col != raylib.WHITE do return true

	return false
}