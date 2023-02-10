package nations


//= Imports
import "core:fmt"

import "../../game"


//= Procedures
set_owned_province :: proc(
	nation : ^game.Nation,
) {
	for prov in nation.ownedProvinces {
		province := &game.provinces[prov]
		province.owner = nation
	}
}
set_all_owned_provinces :: proc() {
	for nation in game.nations {
		set_owned_province(&game.nations[nation])
	}
}