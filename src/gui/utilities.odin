package gui


//= Imports
import "../raylib"


//= Procedures
test_bounds :: proc(pos: raylib.Vector2, bounds: raylib.Rectangle) -> bool {
	result: bool = false;

	result = (pos.x >= bounds.x) & (pos.x <= bounds.x + bounds.width) & (pos.y >= bounds.y) & (pos.y <= bounds.y + bounds.height);

	return result;
}