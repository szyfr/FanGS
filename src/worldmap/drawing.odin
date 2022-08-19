package worldmap


//= Imports
import "../raylib"

import "../gamedata"


//= Procedures
draw_map :: proc() {
	for i:=0;i<len(gamedata.mapdata.chunks);i+=1 {
	//	raylib.draw_model(
	//		gamedata.mapdata.chunks[i].model,
	//		gamedata.mapdata.chunks[i],
	//		1, raylib.WHITE,
	//	)
		raylib.draw_model_ex(
			gamedata.mapdata.chunks[i].model,
			gamedata.mapdata.chunks[i],
			{0,1,0}, 180,
			{10.046, 5, 10.046},
	//		{10, 5, 10},
			raylib.WHITE,
		)
	}
}