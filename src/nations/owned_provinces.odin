package nations


//= Imports
import "../gamedata"


//= Procedures
get_owned_provinces :: proc(nation : ^gamedata.NationData) {

}
set_owned_provinces :: proc(nation : ^gamedata.NationData) {
	for i:=0;i<len(nation.ownedProvinces);i+=1 {
		prov := &gamedata.worlddata.provincesdata[nation.ownedProvinces[i]]
		prov.owner = nation
	}
}
set_all_owned_provinces :: proc() {
	for i:=0;i<len(gamedata.worlddata.nationsdata);i+=1 {
		set_owned_provinces(&gamedata.worlddata.nationsdata[i])
	}
}