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
				if worlddata.provincesdata[col].owner == nil do disp = raylib.RAYWHITE
				else do disp = worlddata.provincesdata[col].owner.color
				// TODO: if prov is impassable get surrounding
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
			case .population:
			case .ancestry:
				switch worlddata.provincesdata[col].avePop.ancestry {
					case  0: disp = raylib.RAYWHITE      //null,
					case  1: disp = {192, 192, 192, 255} //human,
					case  2: disp = { 51, 184,  54, 255} //orc,
					case  3: disp = {171, 228, 172, 255} //half_orc,
					case  4: disp = {211, 189,  33, 255} //elf,
					case  5: disp = {242, 234, 172, 255} //half_elf,
					case  6: disp = {174, 122,  74, 255} //dwarf,
					case 14: disp = { 63, 228,  54, 255} //goblin,
					case 15: disp = {248,  35,  35, 255} //kobold,
				}
			case .culture:
				switch worlddata.provincesdata[col].avePop.culture {
					case  0: disp = raylib.RAYWHITE      //null,
					case  1: disp = { 59,  59,  59, 255} //orc       // black
					case  2: disp = {192, 192, 192, 255} //orc       // gray
					case  3: disp = { 51, 184,  54, 255} //orc       // green
					case  4: disp = {174, 122,  74, 255} //orc       // brown
					case  5: disp = {104, 217, 118, 255} //goblin    // cave
					case  6: disp = {171, 228, 172, 255} //halforc
					case  7: disp = {242, 234, 172, 255} //halfelf
				}
			case .religion:
				switch worlddata.provincesdata[col].avePop.religion {
					case  0: disp = raylib.RAYWHITE      //null,
					case  1: disp = {192, 192, 192, 255} //orc       // great dookan
					case  2: disp = {131, 131, 131, 255} //orc       // old dookan
					case  3: disp = {104, 217, 118, 255} //goblin    // shamanism
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