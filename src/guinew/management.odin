package guinew


//= Imports
import "core:fmt"
import "vendor:raylib"

import "../gamedata"


//= Procedures
update :: proc() {
	using gamedata
	for i:=0; i<len(elements)+1; i+=1 {
		if !(i in elements) do continue

		typeID : GuiElementType = (^GuiElementType)(elements[i])^

		#partial switch typeID {
			case .button: update_button((^Button)(elements[i]))
		}
	}
}

// TODO: Keep an eye on this. Could be glitchy.
draw :: proc() {
	using gamedata
	for i:=0; i<len(elements)+1; i+=1 {
		if !(i in elements) do continue

		typeID : GuiElementType = (^GuiElementType)(elements[i])^

		#partial switch typeID {
			case .label:  draw_label((^Label)(elements[i]))
			case .button: draw_button((^Button)(elements[i]))
		}
	}
}

remove :: proc(id : int) {
	using gamedata

	free(elements[id])
	delete_key(&elements, id)
}

remove_all :: proc() {
	using gamedata

	for i:=0; i<len(elements); i+=1 {
		free(elements[i])
	}

	delete(elements)
	elements = make(map[int]rawptr)
}

generate_id :: proc() -> int {
	using gamedata

	for i:=0;i<len(elements);i+=1 {
		if elements[i] == nil do return i
	}
	return len(elements)
}

test_bounds :: proc(
	position : raylib.Vector2,
	bounds   : raylib.Rectangle,
) -> bool {
	return (position.x >= bounds.x) & (position.x <= bounds.x + bounds.width) & (position.y >= bounds.y) & (position.y <= bounds.y + bounds.height)
}

test_bounds_all :: proc(
	position : raylib.Vector2,
) -> bool {
	using gamedata

	for i:=0; i<len(elements); i+=1 {
		if !(i in elements) do continue

		typeID : GuiElementType = (^GuiElementType)(elements[i])^

		#partial switch typeID {
			case .button:
				rect   := ((^Button)(elements[i])^).transform
				result := !test_bounds(position, rect)
				if result == false do return false
		}
	}

	return true
}