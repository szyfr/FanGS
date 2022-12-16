package worldmap


//= Input
import "core:fmt"
import "core:math"

import "../gamedata"


//= Constants
POPGROWTH_HUMAN   : f32 : 0.001
POPGROWTH_ORC     : f32 : 0.0015
POPGROWTH_HALFORC : f32 : 0.00125
POPGROWTH_ELF     : f32 : 0.00025
POPGROWTH_HALFELF : f32 : 0.00075
POPGROWTH_DWARF   : f32 : 0.0005
POPGROWTH_GOBLIN  : f32 : 0.002
POPGROWTH_KOBOLD  : f32 : 0.002


//= Procedure
grow_province :: proc(prov : ^gamedata.ProvinceData) {
	for i:=0;i<len(prov.popList);i+=1 {
		switch prov.popList[i].ancestry {
			case  1:
			additional := f32(prov.popList[i].pop) * POPGROWTH_HUMAN
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case  2:
			additional := f32(prov.popList[i].pop) * POPGROWTH_ORC
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case  3:
			additional := f32(prov.popList[i].pop) * POPGROWTH_HALFORC
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case  4:
			additional := f32(prov.popList[i].pop) * POPGROWTH_ELF
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case  5:
			additional := f32(prov.popList[i].pop) * POPGROWTH_HALFELF
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case  6:
			additional := f32(prov.popList[i].pop) * POPGROWTH_DWARF
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case 14:
			additional := f32(prov.popList[i].pop) * POPGROWTH_GOBLIN
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
			case 15:
			additional := f32(prov.popList[i].pop) * POPGROWTH_KOBOLD
		fmt.printf("Grow: %v=%v+%v\n",prov.popList[i].pop+u32(math.round(additional)),prov.popList[i].pop,additional)
			prov.popList[i].pop += u32(math.round(additional))
		}
	}
	fmt.printf("\n")

	humanAnc, humanTotal := has_pop_ancestry(prov, 1)
	orcAnc, orcTotal     := has_pop_ancestry(prov, 2)
	elfAnc, elfTotal     := has_pop_ancestry(prov, 4)

	if humanAnc && orcAnc {
		pop : gamedata.Population = {
			u32(f32((humanTotal / 2) + (orcTotal / 2)) * POPGROWTH_HALFORC),
			3,
			6,
			prov.avePop.religion,
			0,
		}
		append_elem(&prov.popList, pop)
	}

	if humanAnc && elfAnc {
		pop : gamedata.Population = {
			u32(f32((humanTotal / 2) + (elfTotal / 2)) * POPGROWTH_HALFELF),
			5,
			7,
			prov.avePop.religion,
			0,
		}
		append_elem(&prov.popList, pop)
	}

	prov.avePop = province_pop_data(prov^)
}

has_pop_ancestry :: proc(prov : ^gamedata.ProvinceData, ancestry : u8) -> (bool, u32) {
	result : bool = false
	total  : u32  = 0
	for i:=0;i<len(prov.popList);i+=1 {
		if prov.popList[i].ancestry == ancestry {
			result = true
			total += prov.popList[i].pop
		}
	}

	return result, total
}