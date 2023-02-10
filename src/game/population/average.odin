package population


//= Imports
import "../../game"


//= Procedures
avearge_province_pop :: proc(
	prov : ^game.Province,
) -> game.Population {
	return {
		total_population(prov),
		mode_ancestry(prov),
		mode_culture(prov),
		mode_religion(prov),
	}
}

//* Calculates total pop
total_population :: proc(
	prov : ^game.Province,
) -> u64 {
	total : u64 = 0
	for pop in prov.popList do total += pop.count
	return total
}

//* Calculates the most populous Ancestry
mode_ancestry :: proc(
	prov : ^game.Province,
) -> ^game.Ancestry {
	ancestryPop : map[^game.Ancestry]u64

	for pop in prov.popList do ancestryPop[pop.ancestry] += pop.count

	value : ^game.Ancestry = nil
	max : u64 = 0
	for pop in ancestryPop {
		if max < ancestryPop[pop] {
			max = ancestryPop[pop]
			value = pop
		}
	}

	return value
}
//* Calculates the most populous Culture
mode_culture :: proc(
	prov : ^game.Province,
) -> ^game.Culture {
	culturePop : map[^game.Culture]u64

	for pop in prov.popList do culturePop[pop.culture] += pop.count

	value : ^game.Culture = nil
	max : u64 = 0
	for pop in culturePop {
		if max < culturePop[pop] {
			max = culturePop[pop]
			value = pop
		}
	}

	return value
}

//* Calculates the most populous Religion
mode_religion :: proc(
	prov : ^game.Province,
) -> ^game.Religion {
	religionPop : map[^game.Religion]u64

	for pop in prov.popList do religionPop[pop.religion] += pop.count

	value : ^game.Religion = nil
	max : u64 = 0
	for pop in religionPop {
		if max < religionPop[pop] {
			max = religionPop[pop]
			value = pop
		}
	}

	return value
}