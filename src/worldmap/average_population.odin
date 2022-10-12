package worldmap


//= Import
import "core:fmt"

import "../gamedata"


//= Procedure
province_pop_data :: proc(prov : gamedata.ProvinceData) -> gamedata.Population {
	pop : gamedata.Population = {
		total_population(prov),
		mode_ancestry(prov),
		mode_culture(prov),
		mode_religion(prov),
		0,
	}
	return pop
}
total_population  :: proc(prov : gamedata.ProvinceData) -> u32 {
	total : u32 = 0

	for i:=0;i<len(prov.popList);i+=1 {
		total += prov.popList[i].pop
	}

	return total
}
mode_ancestry     :: proc(prov : gamedata.ProvinceData) -> u8 {
	values := make(map[u8]u8)
	index  := make([dynamic]u8)

	for i:=0;i<len(prov.popList);i+=1 {
		val, res := values[prov.popList[i].ancestry]

		if !res {
			values[prov.popList[i].ancestry] = 1
			append(&index, prov.popList[i].ancestry)
		} else    do values[prov.popList[i].ancestry] += 1
	}

	highest : u8 = 0
	for i:=0;i<len(values);i+=1 {
		val, res := values[index[i]]

		if res {
			if val > highest do highest = u8(index[i])
		}
	}

	return highest
}
mode_culture      :: proc(prov : gamedata.ProvinceData) -> u8 {
	values := make(map[u8]u8)
	index  := make([dynamic]u8)

	for i:=0;i<len(prov.popList);i+=1 {
		val, res := values[prov.popList[i].culture]

		if !res {
			values[prov.popList[i].culture] = 1
			append(&index, prov.popList[i].culture)
		} else    do values[prov.popList[i].culture] += 1
	}

	highest : u8 = 0
	for i:=0;i<len(values);i+=1 {
		val, res := values[index[i]]

		if res {
			if val > highest do highest = u8(index[i])
		}
	}

	return highest
}
mode_religion     :: proc(prov : gamedata.ProvinceData) -> u8 {
	values := make(map[u8]u8)
	index  := make([dynamic]u8)

	for i:=0;i<len(prov.popList);i+=1 {
		val, res := values[prov.popList[i].religion]

		if !res {
			values[prov.popList[i].religion] = 1
			append(&index, prov.popList[i].religion)
		} else    do values[prov.popList[i].religion] += 1
	}

	highest : u8 = 0
	for i:=0;i<len(values);i+=1 {
		val, res := values[index[i]]

		if res {
			if val > highest do highest = u8(index[i])
		}
	}

	return highest
}