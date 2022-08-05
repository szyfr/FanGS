package localization


//= Imports
import "core:strings"


//= Procedures
copy_string :: proc(array: []u8, offset: ^int) -> (cstring, int) {
	builder: strings.Builder

	for i:=offset^; array[i]!=0; i+=1 {
		offset^ += 1

		if array[i] == 0x0A do break;
		if array[i] == 0x0D {
			offset^ += 1
			break
		}

		strings.write_byte(&builder, array[i])
	}

	str: cstring = strings.clone_to_cstring(strings.to_string(builder))
	strings.reset_builder(&builder)

	return str, offset^
}