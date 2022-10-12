package date


//= Imports
import "core:fmt"

import "vendor:raylib"

import "../gamedata"
import "../worldmap"


//= Procedures
update :: proc() {
	using gamedata

	if !worlddata.timePause && (worlddata.timeDelay == 0 || worlddata.timeSpeed == 0) {
		switch worlddata.timeSpeed {
			case 1: worlddata.timeDelay = 5
			case 2: worlddata.timeDelay = 20
			case 3: worlddata.timeDelay = 35
			case 4: worlddata.timeDelay = 50
		}
		increment_date()
	}
	if worlddata.timeDelay > 0 do worlddata.timeDelay -= 1
}

increment_date :: proc() {
	gamedata.worlddata.date.day += 1

	maxDay : uint = 0
	switch gamedata.worlddata.date.month {
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

	if gamedata.worlddata.date.day > maxDay {
		if gamedata.worlddata.date.month == 12 {
			gamedata.worlddata.date.year  += 1
			gamedata.worlddata.date.month  = 1
		} else do gamedata.worlddata.date.month += 1
		gamedata.worlddata.date.day = 1

		//! Monthly game logic
	//	fmt.printf("Update\n")
		for i:=0;i<len(gamedata.worlddata.provincescolor);i+=1 {
			col := gamedata.worlddata.provincescolor[i]
			worldmap.grow_province(&gamedata.worlddata.provincesdata[col])
		}
	}
}