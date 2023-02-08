package worldmap


//= Imports
import "core:encoding/json"
import "core:fmt"
import "core:math/linalg"
import "core:os"
import "core:strconv"
import "core:strings"

import "vendor:raylib"

import "../../graphics"
import "../../debug"
import "../../game"
import "../../game/settings"
import "../../game/population"
import "../../game/localization"
import "../../game/nations"
import "../../game/provinces"
import "../../utilities/colors"


//= Constants
HEIGHTMAP_RESIZE     :: 4
MAP_RESIZE           :: 20

MAP_PREFIX           :: "data/mods/"

MAPSETTING_LOCATION  :: "/settings.json"
MAPLOCAL_LOCATION    :: "/localization/"
MAPLOCAL_ENDING      :: ".json"

MAPFLAG_PREFIX       :: "/gfx/flags/"
MAPFLAG_EXT          :: ".png"

MAPPROVINCE_LOCATION :: "/map/provinces.json"
MAPNATION_LOCATION   :: "/map/nations.json"

PROVINCE_LOCATION    :: "/map/provincemap.png"
HEIGHT_LOCATION      :: "/map/provincemap.png"
TERRAIN_LOCATION     :: "/map/terrainmap.png"

ERR_MAPSETTINGS_FIND :: "[ERROR]:\tFailed to find Map Settings file."
ERR_MAPLOCAL_FIND    :: "[ERROR]:\tFailed to find Map Localization file."
ERR_MAPPROVINCES_FIND:: "[ERROR]:\tFailed to find Map Provinces file."
ERR_MAPNATIONS_FIND  :: "[ERROR]:\tFailed to find Map Nations file."


//= Procedures
init :: proc(mapname : string) {
	data = new(WorldMapData)

	provLoc := strings.concatenate({MAP_PREFIX, mapname, PROVINCE_LOCATION})
	heigLoc := strings.concatenate({MAP_PREFIX, mapname, HEIGHT_LOCATION})
	terrLoc := strings.concatenate({MAP_PREFIX, mapname, TERRAIN_LOCATION})

	//* Load images
	data.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	data.heightImage   = raylib.LoadImage(strings.clone_to_cstring(heigLoc))
	data.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))
	data.shaderImage   = raylib.ImageCopy(data.provinceImage)

	//* General data
	data.mapWidth  = f32(data.provinceImage.width)  / MAP_RESIZE
	data.mapHeight = f32(data.provinceImage.height) / MAP_RESIZE

	//* Mesh / Model
	height : raylib.Image = raylib.ImageCopy(data.heightImage)
	raylib.ImageResize(&height, height.width/HEIGHTMAP_RESIZE, height.height/HEIGHTMAP_RESIZE)
	data.collisionMesh = raylib.GenMeshHeightmap(height, {data.mapWidth+0.20, 0.5, data.mapHeight+0.20})
	data.model = raylib.LoadModelFromMesh(data.collisionMesh)
	raylib.UnloadImage(height)
	data.model.materials[0].maps[0].texture = raylib.LoadTextureFromImage(data.provinceImage)
	data.model.materials[0].maps[1].texture = raylib.LoadTextureFromImage(data.shaderImage)

	//* Shader
	data.shader = raylib.LoadShader(nil,"data/gfx/shaders/shader.fs")
	data.model.materials[0].shader = data.shader

	create_shader_variable("mapmode", 0)
	create_shader_variable("textureSize", [2]f32{data.mapWidth*MAP_RESIZE, data.mapHeight*MAP_RESIZE})


	//* Load settings
	settingsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPSETTING_LOCATION})
	if !os.is_file(settingsLoc) {
		debug.add_to_log(ERR_MAPSETTINGS_FIND)
		game.state = .mainmenu
		//TODO Add in onscreen error message
		return
	}
	rawData, err := os.read_entire_file_from_filename(settingsLoc)
	jsonData, er := json.parse(rawData)

	data.mapsettings = new(MapSettingsData)
	data.mapsettings.loopMap = jsonData.(json.Object)["loopmap"].(bool)
	
	//* Load time
	dateObj := jsonData.(json.Object)["time"].(json.Object)
	data.date.year  = uint(dateObj["year"].(f64))
	data.date.month = uint(dateObj["month"].(f64))
	data.date.day   = uint(dateObj["day"].(f64))
	data.timePause  = true

	delete(rawData)

	//* Load mod localization
	localizationsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPLOCAL_LOCATION, strings.clone_from_cstring(settings.data.language), MAPLOCAL_ENDING})
	if !os.is_file(localizationsLoc) {
		debug.add_to_log(ERR_MAPLOCAL_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(localizationsLoc)
	jsonData, er = json.parse(rawData)

	//* Ancestry
	ancestryObj := jsonData.(json.Object)["ancestry"].(json.Object)
	for obj in ancestryObj {
		localization.data[obj] = strings.clone_to_cstring(ancestryObj[obj].(json.Object)["local"].(string))
		anc : population.Ancestry = {
			name   = &localization.data[obj],
			growth = f32(ancestryObj[obj].(json.Object)["growth"].(f64)),
			color = {
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		data.ancestryList[obj] = anc
	}

	//* Culture
	cultureObj := jsonData.(json.Object)["culture"].(json.Object)
	for obj in cultureObj {
		anc := &data.ancestryList[obj]

		for objc in cultureObj[obj].(json.Object) {
			localization.data[objc] = strings.clone_to_cstring(cultureObj[obj].(json.Object)[objc].(json.Object)["local"].(string))
			cul : population.Culture = {
				name = &localization.data[objc],
				ancestry = anc,
				color = {
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[0].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[1].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[2].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[3].(f64)),
				},
				// Values
			}
			data.cultureList[objc] = cul
		}
	}
	
	//* Religion
	religionObj := jsonData.(json.Object)["religion"].(json.Object)
	for obj in religionObj {
		localization.data[obj] = strings.clone_to_cstring(religionObj[obj].(json.Object)["local"].(string))
		rel : population.Religion = {
			name = &localization.data[obj],
			color = {
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		data.religionList[obj] = rel
	}

	//* Terrain
	terrainObj := jsonData.(json.Object)["terrain"].(json.Object)
	for obj in terrainObj {
		localization.data[obj] = strings.clone_to_cstring(terrainObj[obj].(json.Object)["local"].(string))
		ter : provinces.Terrain = {
			name  = &localization.data[obj],
			color = {
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		data.terrainList[obj] = ter
	}

	//* Province localization
	provObj := jsonData.(json.Object)["provinces"].(json.Object)
	for obj in provObj {
		localization.data[obj] = strings.clone_to_cstring(provObj[obj].(string))
	}

	//* Nation localization
	nationObj := jsonData.(json.Object)["nations"].(json.Object)
	for obj in nationObj {
		localization.data[obj] = strings.clone_to_cstring(nationObj[obj].(string))
	}

	delete(rawData)

	//* Load Provinces
	mapProvincesLoc := strings.concatenate({MAP_PREFIX, mapname, MAPPROVINCE_LOCATION})
	if !os.is_file(mapProvincesLoc) {
		debug.add_to_log(ERR_MAPPROVINCES_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(mapProvincesLoc)
	jsonData, er = json.parse(rawData)
	
	//* Provinces
	provinceList : map[u32]raylib.Color
	for obj in jsonData.(json.Object) {
		provData := jsonData.(json.Object)[obj].(json.Object)
		value, ok := strconv.parse_u64(obj)
		prov : provinces.ProvinceData = {}

		//* ID number
		//TODO Names
		prov.localID = u32(value)
		prov.name = &localization.data[provData["name"].(string)]

		//* Color
		prov.color = {
			u8(provData["color"].(json.Object)["r"].(f64)),
			u8(provData["color"].(json.Object)["g"].(f64)),
			u8(provData["color"].(json.Object)["b"].(f64)),
			255,
		}
		provinceList[prov.localID] = prov.color

		//* Terrain
		prov.terrain = &data.terrainList[provData["terrain"].(string)]

		//* Type
		switch provData["type"].(string) {
			case "normal":       prov.type = provinces.ProvinceType.base
			case "controllable": prov.type = provinces.ProvinceType.controllable
			case "ocean":        prov.type = provinces.ProvinceType.ocean
			case "lake":         prov.type = provinces.ProvinceType.lake
			case "impassable":   prov.type = provinces.ProvinceType.impassable
		}

		//* Infrastructure
		//TODO Remove max infrastructure and replace with calculation using terrain and mods
		prov.maxInfrastructure = i16(provData["max_infrastructure"].(f64))
		prov.curInfrastructure = i16(provData["cur_infrastructure"].(f64))

		//* Population
		popData := provData["population"].(json.Array)
		for pop in popData {
			population : population.Population = {
				count = u64(pop.(json.Object)["count"].(f64)),

				ancestry = &data.ancestryList[pop.(json.Object)["ancestry"].(string)],
				culture  = &data.cultureList[pop.(json.Object)["culture"].(string)],
				religion = &data.religionList[pop.(json.Object)["religion"].(string)],
			}
			append(&prov.popList, population)
		}
		prov.avePop = provinces.avearge_province_pop(&prov)
		
		//*TODO Buildings
		//*TODO Modifiers
		//*TODO Nation

		//* Shader info
		shaderInfo : ShaderProvince = {
			baseColor = [4]f32{
				f32(prov.color.r) / 255,
				f32(prov.color.g) / 255,
				f32(prov.color.b) / 255,
				f32(prov.color.a) / 255,
			},
			mapColor = [4]f32{
				f32(prov.color.r) / 255,
				f32(prov.color.g) / 255,
				f32(prov.color.b) / 255,
				f32(prov.color.a) / 255,
			},
		}
		prov.shaderIndex = int(create_shader_variable("prov", shaderInfo, prov.localID))

		data.provincesdata[prov.color] = prov
	}

	//* Nations
	mapNationsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPNATION_LOCATION})
	if !os.is_file(mapNationsLoc) {
		debug.add_to_log(ERR_MAPNATIONS_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(mapNationsLoc)
	jsonData, er = json.parse(rawData)

	for obj in jsonData.(json.Object) {
		nation : nations.Nation = {
			localID = jsonData.(json.Object)[obj].(json.Object)["local"].(string),
			color   = {
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["r"].(f64)),
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["g"].(f64)),
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["b"].(f64)),
				255,
			},
			//TODO Name Texture?
		}

		//* Flag
		flaglocation := strings.clone_to_cstring(strings.concatenate({MAP_PREFIX, mapname, MAPFLAG_PREFIX, nation.localID, MAPFLAG_EXT}))
		nation.flag   = raylib.LoadTexture(flaglocation)
		delete(flaglocation)

		//* Owned provinces
		for prov in jsonData.(json.Object)[obj].(json.Object)["provinces"].(json.Array) {
			value, ok := strconv.parse_u64(prov.(string))
			append(&nation.ownedProvinces, provinceList[u32(value)])
		}
		
		//* Centerpoint
		calculate_center(&nation)

		data.nationsList[nation.localID] = nation
	}
	set_all_owned_provinces()

	delete(rawData)
}