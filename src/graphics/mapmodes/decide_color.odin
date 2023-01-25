package mapmodes


//= Imports
import "vendor:raylib"

import "../../game/provinces"


//= Procedures
decide_color :: proc(
	prov      : ^provinces.ProvinceData,
	provColor : raylib.Color,
	mapmode   :  Mapmode,
) {

	#partial switch mapmode {
		case .political:
			if prov.owner != nil do prov.color = prov.owner.color
			else do prov.color = {0,0,0,255}
			break
		case:
			prov.color = provColor
			break
	}

}