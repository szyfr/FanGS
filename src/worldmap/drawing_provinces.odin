package worldmap


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_borders :: proc() {
	using raylib, gamedata

	for i:=0;i<len(gamedata.mapdata.provinces);i+=1 {
		col := gamedata.mapdata.provColors[i]
		res := col in gamedata.mapdata.provinces
	//	fmt.printf("COL: %v\n",len(gamedata.mapdata.provinces[col].borderPoints))
		for o:=0;o<len(gamedata.mapdata.provinces[col].borderPoints);o+=1 {
		//	fmt.printf(
		//		"Point\npos: %v,%v,%v\nnex: %v,%v,%v\n\n",
		//		gamedata.mapdata.provinces[col].borderPoints[o].x, gamedata.mapdata.provinces[col].borderPoints[o].y, gamedata.mapdata.provinces[col].borderPoints[o].z,
		//		gamedata.mapdata.provinces[col].borderPoints[o].next.x, gamedata.mapdata.provinces[col].borderPoints[o].next.y, gamedata.mapdata.provinces[col].borderPoints[o].z,
		//	)
			DrawLine3D(
				gamedata.mapdata.provinces[col].borderPoints[o],
				gamedata.mapdata.provinces[col].borderPoints[o].next,
				raylib.BLACK,
			)
		}
	}
}