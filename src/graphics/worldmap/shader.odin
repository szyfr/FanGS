package worldmap


//= Imports
import "core:fmt"
import "core:strings"

import "vendor:raylib"

import "../../game"


//= Procedures

//* Create shader variables
create_shader_variable :: proc{
	create_shader_variable_name,
	create_shader_variable_single,
	create_shader_variable_array,
	create_shader_variable_array_province,
	create_shader_variable_single_province,
}
create_shader_variable_name :: proc(
	name : string,
) {
	cstr := strings.clone_to_cstring(name)
	game.worldmap.shaderVarLoc[name] = raylib.ShaderLocationIndex(raylib.GetShaderLocation(game.worldmap.shader, cstr))
}
create_shader_variable_single :: proc(
	name  : string,
	value : game.ShaderVariable,
) -> raylib.ShaderLocationIndex {
	cstr := strings.clone_to_cstring(name)
	game.worldmap.shaderVarLoc[name] = raylib.ShaderLocationIndex(raylib.GetShaderLocation(game.worldmap.shader, cstr))
	game.worldmap.shaderVar[name]    = value

	change_shader_variable(name)

	return game.worldmap.shaderVarLoc[name]
}
create_shader_variable_single_province :: proc(
	name  : string,
	value : game.ShaderProvince,
	index : u32,
) -> raylib.ShaderLocationIndex {
	builder : strings.Builder

	str := fmt.sbprintf(&builder, "%s[%i].baseColor", name, index)
	res := create_shader_variable_single(str, value.baseColor)
	strings.builder_reset(&builder)

	str = fmt.sbprintf(&builder, "%s[%i].mapColor", name, index)
	create_shader_variable_single(str, value.mapColor)
	strings.builder_reset(&builder)

	return res
}
create_shader_variable_array :: proc(
	name  : string,
	value : []game.ShaderVariable,
	count : int,
) {
	builder : strings.Builder

	for i:=0;i<len(value);i+=1 {
		str := fmt.sbprintf(&builder, "%s[%i]", name, i)
		create_shader_variable_single(str, value[i])

		strings.builder_reset(&builder)
	}
}
create_shader_variable_array_province :: proc(
	name  : string,
	value : []game.ShaderProvince,
	count : int,
) {
	builder : strings.Builder

	for i:=0;i<len(value);i+=1 {
		str := fmt.sbprintf(&builder, "%s[%i].baseColor", name, i)
		create_shader_variable_single(str, value[i].baseColor)
		strings.builder_reset(&builder)

		str = fmt.sbprintf(&builder, "%s[%i].mapColor", name, i)
		create_shader_variable_single(str, value[i].mapColor)
		strings.builder_reset(&builder)
	}
}

//* Change/Set shader variables
change_shader_variable :: proc{
	change_shader_variable_internal_single,
	change_shader_variable_external_single,
	change_shader_variable_external_array,
//	change_shader_variable_external_array_province,
}
change_shader_variable_internal_single :: proc(
	name  : string,
) {
	value := &game.worldmap.shaderVar[name]
	type  : raylib.ShaderUniformDataType = .FLOAT

	switch v in value^ {
		case i32:    type = .INT
		case f32:    type = .FLOAT
		case [2]f32: type = .VEC2
		case [3]f32: type = .VEC3
		case [4]f32: type = .VEC4
		case [2]i32: type = .IVEC2
		case [3]i32: type = .IVEC3
		case [4]i32: type = .IVEC4
	}

	raylib.SetShaderValue(game.worldmap.shader, game.worldmap.shaderVarLoc[name], value, type)
}
change_shader_variable_external_single :: proc(
	name  : string,
	value : game.ShaderVariable,
) {
	game.worldmap.shaderVar[name] = value
	type  : raylib.ShaderUniformDataType = .FLOAT

	switch v in value {
		case i32:    type = .INT
		case f32:    type = .FLOAT
		case [2]f32: type = .VEC2
		case [3]f32: type = .VEC3
		case [4]f32: type = .VEC4
		case [2]i32: type = .IVEC2
		case [3]i32: type = .IVEC3
		case [4]i32: type = .IVEC4
	}

	raylib.SetShaderValue(game.worldmap.shader, game.worldmap.shaderVarLoc[name], &game.worldmap.shaderVar[name], type)
}
change_shader_variable_external_array :: proc(
	name  : string,
	value : []game.ShaderVariable,
	count : int,
) {
	builder : strings.Builder

	for i:=0;i<len(value);i+=1 {
		str := fmt.sbprintf(&builder, "%s[%i]", name, i)
		change_shader_variable_external_single(str, value[i])

		strings.builder_reset(&builder)
	}
}