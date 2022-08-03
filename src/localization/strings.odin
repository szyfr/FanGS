package localization


//= Imports
import "core:strings"


//= Procedures
copy_string :: proc(array: []u8, offset: ^int) -> (string, int) {
	builder: strings.Builder;

	for i:=offset^; array[i]!=0; i+=1 {
		offset^ += 1;

		if array[i] == 10 do break;

		strings.write_byte(&builder, array[i]);
	}

	str: string = strings.clone(strings.to_string(builder));

	strings.reset_builder(&builder);

	return str, offset^;
}