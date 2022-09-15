package colors


//= Imports
import "vendor:raylib"


//= Procedures
//* Compares two colors
compare_colors :: proc(
	col1,col2 : raylib.Color,
) -> bool {
	result : bool = true

	if col1.r != col2.r do result = false
	if col1.g != col2.g do result = false
	if col1.b != col2.b do result = false

	return result
}