package matrix_math


//= Imports
import "core:math/linalg"


//= Procedures
mat_mult :: proc(
	left  : linalg.Matrix4x4f32,
	right : linalg.Matrix4x4f32,
) -> linalg.Matrix4x4f32 {
	result : linalg.Matrix4x4f32 = {}

	result[0,0] = left[0,0]*right[0,0] + left[0,1]*right[1,0] + left[0,2]*right[2,0] + left[0,3]*right[3,0]
	result[0,1] = left[0,0]*right[0,1] + left[0,1]*right[1,1] + left[0,2]*right[2,1] + left[0,3]*right[3,1]
	result[0,2] = left[0,0]*right[0,2] + left[0,1]*right[1,2] + left[0,2]*right[2,2] + left[0,3]*right[3,2]
	result[0,3] = left[0,0]*right[0,3] + left[0,1]*right[1,3] + left[0,2]*right[2,3] + left[0,3]*right[3,3]
	
	result[1,0] = left[1,0]*right[0,0] + left[1,1]*right[1,0] + left[1,2]*right[2,0] + left[1,3]*right[3,0]
	result[1,1] = left[1,0]*right[0,1] + left[1,1]*right[1,1] + left[1,2]*right[2,1] + left[1,3]*right[3,1]
	result[1,2] = left[1,0]*right[0,2] + left[1,1]*right[1,2] + left[1,2]*right[2,2] + left[1,3]*right[3,2]
	result[1,3] = left[1,0]*right[0,3] + left[1,1]*right[1,3] + left[1,2]*right[2,3] + left[1,3]*right[3,3]
	
	result[2,0] = left[2,0]*right[0,0] + left[2,1]*right[1,0] + left[2,2]*right[2,0] + left[2,3]*right[3,0]
	result[2,1] = left[2,0]*right[0,1] + left[2,1]*right[1,1] + left[2,2]*right[2,1] + left[2,3]*right[3,1]
	result[2,2] = left[2,0]*right[0,2] + left[2,1]*right[1,2] + left[2,2]*right[2,2] + left[2,3]*right[3,2]
	result[2,3] = left[2,0]*right[0,3] + left[2,1]*right[1,3] + left[2,2]*right[2,3] + left[2,3]*right[3,3]
	
	result[3,0] = left[3,0]*right[0,0] + left[3,1]*right[1,0] + left[3,2]*right[2,0] + left[3,3]*right[3,0]
	result[3,1] = left[3,0]*right[0,1] + left[3,1]*right[1,1] + left[3,2]*right[2,1] + left[3,3]*right[3,1]
	result[3,2] = left[3,0]*right[0,2] + left[3,1]*right[1,2] + left[3,2]*right[2,2] + left[3,3]*right[3,2]
	result[3,3] = left[3,0]*right[0,3] + left[3,1]*right[1,3] + left[3,2]*right[2,3] + left[3,3]*right[3,3]

	return result
}
mat_add :: proc(
	left  : linalg.Matrix4x4f32,
	right : linalg.Matrix4x4f32,
) -> linalg.Matrix4x4f32 {
	result : linalg.Matrix4x4f32 = {}

	result[0,0] = left[0,0] + right[0,0]
	result[0,1] = left[0,1] + right[0,1]
	result[0,2] = left[0,2] + right[0,2]
	result[0,3] = left[0,3] + right[0,3]

	result[1,0] = left[1,0] + right[1,0]
	result[1,1] = left[1,1] + right[1,1]
	result[1,2] = left[1,2] + right[1,2]
	result[1,3] = left[1,3] + right[1,3]

	result[2,0] = left[2,0] + right[2,0]
	result[2,1] = left[2,1] + right[2,1]
	result[2,2] = left[2,2] + right[2,2]
	result[2,3] = left[2,3] + right[2,3]

	result[3,0] = left[3,0] + right[3,0]
	result[3,1] = left[3,1] + right[3,1]
	result[3,2] = left[3,2] + right[3,2]
	result[3,3] = left[3,3] + right[3,3]

	return result
}

mat_add_trans :: proc(
	mat : linalg.Matrix4x4f32,
	vec : linalg.Vector3f32,
) -> linalg.Matrix4x4f32 {
	mod : linalg.Matrix4x4f32 = {
		    1,     0,     0, 0,
		    0,     5,     0, 0,
		    0,     0,     1, 0,
		vec.x, vec.y, vec.z, 1,
	}

	return mat_mult(mat,mod)
}