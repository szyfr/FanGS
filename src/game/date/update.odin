package date


//= Imports
import "core:fmt"
import "core:strings"

import "../../game"
import "../provinces"


//= Procedures
update :: proc() {
	if !game.worldmap.timePause && (game.worldmap.timeDelay == 0 || game.worldmap.timeSpeed == 0) {
		switch game.worldmap.timeSpeed {
			case 1: game.worldmap.timeDelay = 5
			case 2: game.worldmap.timeDelay = 20
			case 3: game.worldmap.timeDelay = 35
			case 4: game.worldmap.timeDelay = 50
		}
		increment_date()
	}
	if game.worldmap.timeDelay > 0 do game.worldmap.timeDelay -= 1
}

increment_date :: proc() {
	game.worldmap.date.day += 1

	maxDay : uint = 0
	switch game.worldmap.date.month {
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

	if game.worldmap.date.day > maxDay {
		if game.worldmap.date.month == 12 {
			game.worldmap.date.year  += 1
			game.worldmap.date.month  = 1
		} else do game.worldmap.date.month += 1
		game.worldmap.date.day = 1

		//! Monthly game logic
		fmt.printf("Update\n")
		for prov in game.provinces {
			provinces.grow_province(&game.provinces[prov])
		}
	}
}