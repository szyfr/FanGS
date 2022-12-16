package nations


//= Imports
import "vendor:raylib"

import "../gamedata"


//= Procedures
calculate_center :: proc(nation : ^gamedata.NationData) {
	total : raylib.Vector3 = {0,0,0}
	for i:=0;i<len(nation.ownedProvinces);i+=1 {
		total += gamedata.worlddata.provincesdata[nation.ownedProvinces[i]].centerpoint
	}
	total = {
		total.x / f32(len(nation.ownedProvinces)),
		total.y / f32(len(nation.ownedProvinces)),
		total.z / f32(len(nation.ownedProvinces)),
	}
	nation.centerpoint = total
}