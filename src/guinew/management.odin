package guinew


//= Imports
import "core:fmt"

import "../raylib"

import "../gamedata"


//= Procedures
update :: proc() {
	using gamedata
	for i:=0; i<len(elements); i+=1 {
		typeID : GuiElementType = (^GuiElementType)(elements[i])^

		#partial switch typeID {
			case .button: update_button((^Button)(elements[i]))
		}
	}
}

draw :: proc() {
	using gamedata
	for i:=0; i<len(elements); i+=1 {
		typeID : GuiElementType = (^GuiElementType)(elements[i])^

		#partial switch typeID {
			case .label:  draw_label((^Label)(elements[i]))
			case .button: draw_button((^Button)(elements[i]))
		}
	}
}

remove :: proc(index : int) {
	using gamedata

	arr : [dynamic]rawptr
	ptr : rawptr = elements[index]

	for i:=0; i<len(elements); i+=1 {
		if i != index do append(&arr, elements[i])
	}

	free(ptr)
}

remove_all :: proc() {
	using gamedata

	for i:=0; i<len(elements); i+=1 {
		free(elements[i])
	}

	delete(elements)
	elements = new([dynamic]rawptr)^
}

test_bounds :: proc(
	position : raylib.Vector2,
	bounds   : raylib.Rectangle,
) -> bool {
	return (position.x >= bounds.x) & (position.x <= bounds.x + bounds.width) & (position.y >= bounds.y) & (position.y <= bounds.y + bounds.height)
}