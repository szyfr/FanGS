package worldmap


//= Imports
import "core:math/linalg"
import "vendor:raylib"

import "../gamedata"
import "../utilities/matrix_math"


//= Procedures
draw_map :: proc() {
	using gamedata
	
	//* Drawing main map
	for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
		chunk := gamedata.mapdata.chunks[i]
		raylib.DrawMesh(
			chunk.mesh,
			chunk.mat,
			chunk.transform,
		)
	}
	if mapdata.mapsettings.loopMap {
		//* Drawing left loop
		for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
			width := mapdata.provinceImage.width/250
			if i32(i) % width >= width - 5 {
				chunk     := gamedata.mapdata.chunks[i]
				mod : linalg.Matrix4x4f32 = {
					            1, 0, 0, 0,
					            0, 1, 0, 0,
					            0, 0, 1, 0,
					f32(width*10), 0, 0, 1,
				}
				raylib.DrawMesh(
					chunk.mesh,
					chunk.mat,
					matrix_math.mat_mult(chunk.transform, mod),
				)
			}
		}
		//* Drawing right loop
		for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
			width := mapdata.provinceImage.width/250
			if i32(i) % width <= 5 {
				chunk     := gamedata.mapdata.chunks[i]
				mod : linalg.Matrix4x4f32 = {
					            1, 0, 0, 0,
					            0, 1, 0, 0,
					            0, 0, 1, 0,
				   -f32(width*10), 0, 0, 1,
				}
				raylib.DrawMesh(
					chunk.mesh,
					chunk.mat,
					matrix_math.mat_mult(chunk.transform, mod),
				)
			}
		}
	}
}