package date


//= Imports
import "vendor:raylib"

import "../gamedata"
import "../worldmap"


//= Procedures
update :: proc() {
	using gamedata

	if !worlddata.timePause && (worlddata.timeDelay == 0 || worlddata.timeSpeed == 0) {
		switch worlddata.timeSpeed {
			case 1:
				worlddata.timeDelay = 2000
			case 2:
				worlddata.timeDelay = 4000
			case 3:
				worlddata.timeDelay = 6000
			case 4:
				worlddata.timeDelay = 8000
		}
		worlddata.date.day += 1
	}
	if worlddata.timeDelay > 0 do worlddata.timeDelay -= 1
}