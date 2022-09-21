package worldmap


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_provinces :: proc() {
	using gamedata, raylib
	rlDisableDepthTest()

	for i:=0;i<len(gamedata.worlddata.provincescolor);i+=1 {
		col  := worlddata.provincescolor[i]
		disp := worlddata.provincescolor[i]

		if &worlddata.provincesdata[worlddata.provincescolor[i]] == playerdata.currentSelection {
			disp = RED
		}

		//* Draw center
		DrawModelEx(
			gamedata.worlddata.provincesdata[col].provmodel,
			{
				-gamedata.worlddata.provincesdata[col].centerpoint.x,
				-gamedata.worlddata.provincesdata[col].centerpoint.y,
				-gamedata.worlddata.provincesdata[col].centerpoint.z,
			},
			{0,1,0}, 180,
			{1, 1, 1},
			disp,
		)

		//* Draw left
		if gamedata.worlddata.provincesdata[col].centerpoint.x > worlddata.mapWidth - 100 {
			DrawModelEx(
				gamedata.worlddata.provincesdata[col].provmodel,
				{
					worlddata.mapWidth-gamedata.worlddata.provincesdata[col].centerpoint.x,
					-gamedata.worlddata.provincesdata[col].centerpoint.y,
					-gamedata.worlddata.provincesdata[col].centerpoint.z,
				},
				{0,1,0}, 180,
				{1, 1, 1},
				disp,
			)
		}
		
		//* Draw right
		if gamedata.worlddata.provincesdata[col].centerpoint.x < 100 {
			DrawModelEx(
				gamedata.worlddata.provincesdata[col].provmodel,
				{
					-worlddata.mapWidth-gamedata.worlddata.provincesdata[col].centerpoint.x,
					-gamedata.worlddata.provincesdata[col].centerpoint.y,
					-gamedata.worlddata.provincesdata[col].centerpoint.z,
				},
				{0,1,0}, 180,
				{1, 1, 1},
				disp,
			)
		}
		
	//	fmt.printf("%v\n",-gamedata.worlddata.provincesdata[col].centerpoint)
	}

	rlEnableDepthTest()
}