package date


//= Imports
import "vendor:raylib"

import "../gamedata"
import "../worldmap"


//= Procedures
update :: proc() {
	using gamedata

	if !worlddata.timePause && (worlddata.timeDelay == 0 || worlddata.timeSpeed == 0) {
		//TODO: Tune this
		switch worlddata.timeSpeed {
			case 1: worlddata.timeDelay = 5
			case 2: worlddata.timeDelay = 20
			case 3: worlddata.timeDelay = 35
			case 4: worlddata.timeDelay = 50
		}
		worlddata.date.day += 1
	}
	if worlddata.timeDelay > 0 do worlddata.timeDelay -= 1
}