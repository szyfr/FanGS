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
			id   := gamedata.mapdata.provinces[col].borderPoints[o].idNext
			ncol := BLACK
			if &gamedata.mapdata.provinces[col] == gamedata.playerdata.currentSelection do ncol = RED

			newPosition1 := Vector3{
				-gamedata.mapdata.provinces[col].borderPoints[o].pos.x/25,
				-gamedata.mapdata.provinces[col].borderPoints[o].pos.y,
				-gamedata.mapdata.provinces[col].borderPoints[o].pos.z/25,
			}
			newPosition2 := Vector3{
				-gamedata.mapdata.provinces[col].borderPoints[id].pos.x/25,
				-gamedata.mapdata.provinces[col].borderPoints[id].pos.y,
				-gamedata.mapdata.provinces[col].borderPoints[id].pos.z/25,
			}

			DrawLine3D(
				newPosition1,
				newPosition2,
			//	-gamedata.mapdata.provinces[col].borderPoints[o].pos,
			//	-gamedata.mapdata.provinces[col].borderPoints[id].pos,
				ncol,
			)
		}
	}
}