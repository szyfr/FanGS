package provinces


//= Import
import "core:fmt"
import "core:math"

import "../../game"
import "../../game/population"


//= Procedures
grow_province :: proc(
	province : ^game.Province,
) {
	for i:=0;i<len(province.popList);i+=1 {
		province.popList[i].count += u64(math.round(f32(province.popList[i].count) * province.popList[i].ancestry.growth))
	}

	//? Implement Half-Elves/Half-Orcs/Half-etc?
	//? Possibly include "Can mix" in ancestry data?
	//? Halfling's culture conversions

	province.avePop = population.avearge_province_pop(province)
}