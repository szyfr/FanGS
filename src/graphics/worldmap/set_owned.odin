package worldmap


//= Imports
import "../../game/nations"


//= Procedures
set_owned_province :: proc(
	nation : ^nations.Nation,
) {
	for prov in nation.ownedProvinces {
		province := &data.provincesdata[prov]
		province.owner = nation
	}
}
set_all_owned_provinces :: proc() {
	for nation in data.nationsList {
		set_owned_province(&data.nationsList[nation])
	}
}