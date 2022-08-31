package worldmap


//= Imports
import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_map :: proc() {
	for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
//	for i:=1;i<2;i+=1 {
//	for i:=0;i<1;i+=1 {
		chunk := gamedata.mapdata.chunks[i]
		raylib.DrawMesh(
			chunk.mesh,
			chunk.mat,
			chunk.transform,
		)
	//	raylib.DrawMesh(
	//		gamedata.mapdata.chunks[i].mesh,
	//		gamedata.mapdata.chunks[i].mat,
	//		gamedata.mapdata.chunks[i].transform,
	//	)
	//	raylib.DrawModelEx(
	//		gamedata.mapdata.chunks[i].model,
	//		gamedata.mapdata.chunks[i],
	//		{0,1,0}, 180,
	//		{1, 5, 1},
	//		raylib.WHITE,
	//	)
	}
}