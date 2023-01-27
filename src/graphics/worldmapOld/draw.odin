package worldmap


//= Imports
import "vendor:raylib"

//import "../../game/player"


//= Procedures
draw :: proc() {
	raylib.rlDisableDepthTest()

//	for i:=0;i<len(data.provincescolor);i+=1 {
	for prov in data.provincesdata {
		//TODO remove this variable
		col  := prov
		disp := data.provincesdata[col].color

		//* Draw center
		raylib.DrawModelEx(
			data.provincesdata[col].provmodel,
			{
				-data.provincesdata[col].centerpoint.x,
				-data.provincesdata[col].centerpoint.y,
				-data.provincesdata[col].centerpoint.z,
			},
			{0,1,0}, 180,
			{1, 1, 1},
			disp,
		)
		//TODO: Figure out something to do with province names
		//TODO: WHY THE EVERLOVING FUCK DOES REMOVING THIS FUNCTION STOP THE MODELS FROM DRAWING
		//if player.data.zoom <= 8 {
			//* Province names
			raylib.DrawBillboardPro(
				{},
				data.provincesdata[col].nametx,
				{
					0, 0,
					f32(data.provincesdata[col].nametx.width),
					f32(data.provincesdata[col].nametx.height),
				},
				{
					-data.provincesdata[col].centerpoint.x,
					-data.provincesdata[col].centerpoint.y,
					-data.provincesdata[col].centerpoint.z,
				},
				{0,0,1},
				{1,1},
				{0,0},
				1,
				raylib.BLACK,
			)
		//}

		//* Draw left
		if data.provincesdata[col].centerpoint.x > data.mapWidth - 100 {
			raylib.DrawModelEx(
				data.provincesdata[col].provmodel,
				{
					data.mapWidth-data.provincesdata[col].centerpoint.x,
					-data.provincesdata[col].centerpoint.y,
					-data.provincesdata[col].centerpoint.z,
				},
				{0,1,0}, 180,
				{1, 1, 1},
				disp,
			)
		}
		
		//* Draw right
		if data.provincesdata[col].centerpoint.x < 100 {
			raylib.DrawModelEx(
				data.provincesdata[col].provmodel,
				{
					-data.mapWidth-data.provincesdata[col].centerpoint.x,
					-data.provincesdata[col].centerpoint.y,
					-data.provincesdata[col].centerpoint.z,
				},
				{0,1,0}, 180,
				{1, 1, 1},
				disp,
			)
		}
	}

	raylib.rlEnableDepthTest()
}