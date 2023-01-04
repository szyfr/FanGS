package elements


//= Imports
import "vendor:raylib"


//= Procedures

test_bounds :: proc(
	position : raylib.Vector2,
	bounds   : raylib.Rectangle,
) -> bool {
	return (position.x >= bounds.x) & (position.x <= bounds.x + bounds.width) & (position.y >= bounds.y) & (position.y <= bounds.y + bounds.height)
}