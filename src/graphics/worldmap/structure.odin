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
	//* Drawing
	provinceImage  : raylib.Image,
	heightImage    : raylib.Image,
	terrainImage   : raylib.Image,
	shaderImage    : raylib.Image,

	collisionMesh  : raylib.Mesh,
	model          : raylib.Model,
	shader         : raylib.Shader,

	shaderVarLoc   : map[string]raylib.ShaderLocationIndex,
	shaderVar      : map[string]ShaderVariable,

	mapHeight      : f32,
	mapWidth       : f32,


	//* Data

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

ShaderVariable :: union {
	i32,
	f32,
	[2]f32,
	[3]f32,
	[4]f32,
	[2]i32,
	[3]i32,
	[4]i32,
}
ShaderProvince :: struct {
	baseColor : ShaderVariable,
	mapColor  : ShaderVariable,
}

MapSettingsData :: struct {
	loopMap : bool,
}


Date :: struct {
	year  : uint,
	month : uint,
	day   : uint,
}