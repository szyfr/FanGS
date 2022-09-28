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

		#partial switch playerdata.curMapmode {
			case .overworld:
			case .political:
			case .terrain:
				#partial switch worlddata.provincesdata[col].terrain {
					// TODO: plains, swamp, other holds, caves
					case .NULL:       disp = raylib.RAYWHITE
					case .deep_road:  disp = {200, 146,  79, 255}
					case .dwarf_hold: disp = {150, 104, 225, 255}
				}
			case .control:
				#partial switch worlddata.provincesdata[col].provType {
					case .base:         disp = { 33, 227, 101, 255}
					case .controllable: disp = {225, 223,  21, 255}
					case .water:        disp = { 27, 136, 239, 255}
					case .impassable:   disp = {158, 185, 198, 255}
				}
		}

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