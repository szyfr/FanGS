package date


//= Imports
import "core:fmt"
import "core:strings"

import "../../graphics/worldmap"


//= Procedures
update :: proc() {
	if !worldmap.data.timePause && (worldmap.data.timeDelay == 0 || worldmap.data.timeSpeed == 0) {
		switch worldmap.data.timeSpeed {
			case 1: worldmap.data.timeDelay = 5
			case 2: worldmap.data.timeDelay = 20
			case 3: worldmap.data.timeDelay = 35
			case 4: worldmap.data.timeDelay = 50
		}
		increment_date()
	}
	if worldmap.data.timeDelay > 0 do worldmap.data.timeDelay -= 1
}

increment_date :: proc() {
	worldmap.data.date.day += 1

	maxDay : uint = 0
	switch worldmap.data.date.month {
		case  1: maxDay = 31
		case  2: maxDay = 28
		case  3: maxDay = 31
		case  4: maxDay = 30
		case  5: maxDay = 31
		case  6: maxDay = 30
		case  7: maxDay = 31
		case  8: maxDay = 31
		case  9: maxDay = 30
		case 10: maxDay = 31
		case 11: maxDay = 30
		case 12: maxDay = 31
	}

	if worldmap.data.date.day > maxDay {
		if worldmap.data.date.month == 12 {
			worldmap.data.date.year  += 1
			worldmap.data.date.month  = 1
		} else do worldmap.data.date.month += 1
		worldmap.data.date.day = 1

		//! Monthly game logic
	//	fmt.printf("Update\n")
		//for i:=0;i<len(worldmap.data.provincescolor);i+=1 {
		//	col := worldmap.data.provincescolor[i]
		//	worldmap.grow_province(&worldmap.data.provincesdata[col])
		//}
	}
}