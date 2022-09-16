package worldmap_new


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_provinces :: proc() {
	using gamedata, raylib

	for i:=0;i<len(gamedata.worlddata.provincescolor);i+=1 {
		col := gamedata.worlddata.provincescolor[i]
		DrawModelEx(
			gamedata.worlddata.provincesdata[col].provmodel,
			{
				-gamedata.worlddata.provincesdata[col].centerpoint.x,
				-gamedata.worlddata.provincesdata[col].centerpoint.y+(f32(i)*.0001),
				-gamedata.worlddata.provincesdata[col].centerpoint.z,
			},
			{0,1,0}, 180,
			{1, 1, 1},
			WHITE,
		)
	//	fmt.printf("%v\n",-gamedata.worlddata.provincesdata[col].centerpoint)
	}
}