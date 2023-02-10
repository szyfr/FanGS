package nations


//= Imports
import "vendor:raylib"

import "../../game"


//= Procedures
calculate_center :: proc(
	nation : ^game.Nation,
) {
	total : raylib.Vector3 = {0,0,0}
	for prov in nation.ownedProvinces do total += game.provinces[prov].centerpoint

	total = {
		total.x / f32(len(nation.ownedProvinces)),
		total.y / f32(len(nation.ownedProvinces)),
		total.z / f32(len(nation.ownedProvinces)),
	}
	nation.centerpoint = total
}