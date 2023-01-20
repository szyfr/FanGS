package worldmap


//= Imports
import "vendor:raylib"
import "../../game/nations"
import "../../game/provinces"
import "../../game/population"


//= Global
data : ^WorldMapData


//= Structures
WorldMapData :: struct {
	provinceImage  : raylib.Image,
	terrainImage   : raylib.Image,

	collisionMesh  : raylib.Mesh,

	mapHeight      : f32,
	mapWidth       : f32,

	provincesdata  : map[raylib.Color]provinces.ProvinceData,

	nationsList  : map[string]nations.Nation,
	ancestryList : map[string]population.Ancestry,
	cultureList  : map[string]population.Culture,
	religionList : map[string]population.Religion,
	terrainList  : map[string]provinces.Terrain,

	provincePixelCount : int,

	mapsettings    : ^MapSettingsData,

	date      : Date,
	timeSpeed : uint,
	timeDelay : uint,
	timePause : bool,
}

MapSettingsData :: struct {
	loopMap : bool,
}


Date :: struct {
	year  : uint,
	month : uint,
	day   : uint,
}