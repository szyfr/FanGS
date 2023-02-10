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
import "../../game/localization"
import "../../game/provinces"
import "../../game/nations"
import "../../game/population"
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
init_new :: proc() {
	//* Load
	//* - List of mods
	//* - Localization
	//* - Ancestry
	//* - Culture
	//* - Religion
	//* - Terrain
	//* - 
	//* - Map
	//? - Maybe add in multiple map functionality?
	//* - Provinces
	//* - Nations
}

init :: proc(mapname : string) {
	game.worldmap = new(game.Worldmap)

	provLoc := strings.concatenate({MAP_PREFIX, mapname, PROVINCE_LOCATION})
	heigLoc := strings.concatenate({MAP_PREFIX, mapname, HEIGHT_LOCATION})
	terrLoc := strings.concatenate({MAP_PREFIX, mapname, TERRAIN_LOCATION})

	//* Load images
	game.worldmap.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	game.worldmap.heightImage   = raylib.LoadImage(strings.clone_to_cstring(heigLoc))
	game.worldmap.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))

	//* General data
	game.worldmap.mapWidth  = f32(game.worldmap.provinceImage.width)  / MAP_RESIZE
	game.worldmap.mapHeight = f32(game.worldmap.provinceImage.height) / MAP_RESIZE

	//* Mesh / Model
	height : raylib.Image = raylib.ImageCopy(game.worldmap.heightImage)
	raylib.ImageResize(&height, height.width/HEIGHTMAP_RESIZE, height.height/HEIGHTMAP_RESIZE)
	game.worldmap.collisionMesh = raylib.GenMeshHeightmap(height, {game.worldmap.mapWidth+0.20, 0.5, game.worldmap.mapHeight+0.20})
	game.worldmap.model = raylib.LoadModelFromMesh(game.worldmap.collisionMesh)
	raylib.UnloadImage(height)
	game.worldmap.model.materials[0].maps[0].texture = raylib.LoadTextureFromImage(game.worldmap.provinceImage)

	//* Shader
	game.worldmap.shader = raylib.LoadShader(nil,"data/gfx/shaders/shader.fs")
	game.worldmap.model.materials[0].shader = game.worldmap.shader

	create_shader_variable("mapmode", 0)
	create_shader_variable("textureSize", [2]f32{game.worldmap.mapWidth*MAP_RESIZE, game.worldmap.mapHeight*MAP_RESIZE})


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

	game.worldmap.mapsettings = new(game.MapSettingsData)
	game.worldmap.mapsettings.loopMap = jsonData.(json.Object)["loopmap"].(bool)
	
	//* Load time
	dateObj := jsonData.(json.Object)["time"].(json.Object)
	game.worldmap.date.year  = uint(dateObj["year"].(f64))
	game.worldmap.date.month = uint(dateObj["month"].(f64))
	game.worldmap.date.day   = uint(dateObj["day"].(f64))
	game.worldmap.timePause  = true

	delete(rawData)

	//* Load mod localization
	localizationsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPLOCAL_LOCATION, strings.clone_from_cstring(game.settings.language), MAPLOCAL_ENDING})
	if !os.is_file(localizationsLoc) {
		debug.add_to_log(ERR_MAPLOCAL_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(localizationsLoc)
	jsonData, er = json.parse(rawData)

	//* Ancestry
	ancestryObj := jsonData.(json.Object)["ancestry"].(json.Object)
	for obj in ancestryObj {
		game.localization[obj] = strings.clone_to_cstring(ancestryObj[obj].(json.Object)["local"].(string))
		anc : game.Ancestry = {
			name   = &game.localization[obj],
			growth = f32(ancestryObj[obj].(json.Object)["growth"].(f64)),
			color = {
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		game.ancestries[obj] = anc
	}

	//* Culture
	cultureObj := jsonData.(json.Object)["culture"].(json.Object)
	for obj in cultureObj {
		anc := &game.ancestries[obj]

		for objc in cultureObj[obj].(json.Object) {
			game.localization[objc] = strings.clone_to_cstring(cultureObj[obj].(json.Object)[objc].(json.Object)["local"].(string))
			cul : game.Culture = {
				name = &game.localization[objc],
				ancestry = anc,
				color = {
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[0].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[1].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[2].(f64)),
					u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[3].(f64)),
				},
				// Values
			}
			game.cultures[objc] = cul
		}
	}
	
	//* Religion
	religionObj := jsonData.(json.Object)["religion"].(json.Object)
	for obj in religionObj {
		game.localization[obj] = strings.clone_to_cstring(religionObj[obj].(json.Object)["local"].(string))
		rel : game.Religion = {
			name = &game.localization[obj],
			color = {
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(religionObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		game.religions[obj] = rel
	}

	//* Terrain
	terrainObj := jsonData.(json.Object)["terrain"].(json.Object)
	for obj in terrainObj {
		game.localization[obj] = strings.clone_to_cstring(terrainObj[obj].(json.Object)["local"].(string))
		ter : game.Terrain = {
			name  = &game.localization[obj],
			color = {
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(terrainObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Values
		}
		game.terrains[obj] = ter
	}

	//* Province localization
	provObj := jsonData.(json.Object)["provinces"].(json.Object)
	for obj in provObj {
		game.localization[obj] = strings.clone_to_cstring(provObj[obj].(string))
	}

	//* Nation localization
	nationObj := jsonData.(json.Object)["nations"].(json.Object)
	for obj in nationObj {
		game.localization[obj] = strings.clone_to_cstring(nationObj[obj].(string))
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
		prov : game.Province = {}

		//* ID number
		//TODO Names
		prov.localID = u32(value)
		prov.name = &game.localization[provData["name"].(string)]

		//* Color
		prov.color = {
			u8(provData["color"].(json.Object)["r"].(f64)),
			u8(provData["color"].(json.Object)["g"].(f64)),
			u8(provData["color"].(json.Object)["b"].(f64)),
			255,
		}
		provinceList[prov.localID] = prov.color

		//* Terrain
		prov.terrain = &game.terrains[provData["terrain"].(string)]

		//* Type
		switch provData["type"].(string) {
			case "normal":       prov.type = .base
			case "controllable": prov.type = .controllable
			case "ocean":        prov.type = .ocean
			case "lake":         prov.type = .lake
			case "impassable":   prov.type = .impassable
		}

		//* Infrastructure
		//TODO Remove max infrastructure and replace with calculation using terrain and mods
		prov.maxInfrastructure = i16(provData["max_infrastructure"].(f64))
		prov.curInfrastructure = i16(provData["cur_infrastructure"].(f64))

		//* Population
		popData := provData["population"].(json.Array)
		for pop in popData {
			population : game.Population = {
				count = u64(pop.(json.Object)["count"].(f64)),

				ancestry = &game.ancestries[pop.(json.Object)["ancestry"].(string)],
				culture  = &game.cultures[pop.(json.Object)["culture"].(string)],
				religion = &game.religions[pop.(json.Object)["religion"].(string)],
			}
			append(&prov.popList, population)
		}
		prov.avePop = population.avearge_province_pop(&prov)
		
		//*TODO Buildings
		//*TODO Modifiers
		//*TODO Nation

		//* Shader info
		shaderInfo : game.ShaderProvince = {
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

		game.provinces[prov.color] = prov
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
		nation : game.Nation = {
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
		nations.calculate_center(&nation)

		game.nations[nation.localID] = nation
	}
	nations.set_all_owned_provinces()

	delete(rawData)
}

close :: proc() {
	//* Worldmap
	raylib.UnloadImage(game.worldmap.provinceImage)
	raylib.UnloadImage(game.worldmap.heightImage)
	raylib.UnloadImage(game.worldmap.terrainImage)
	raylib.UnloadModel(game.worldmap.model)
	raylib.UnloadShader(game.worldmap.shader)

	delete(game.worldmap.shaderVarLoc)
	delete(game.worldmap.shaderVar)

	free(game.worldmap.mapsettings)
	free(game.worldmap)

	//* Mod data
	delete(game.provinces)
	game.provinces  = make(map[raylib.Color]game.Province)
	delete(game.nations)
	game.nations    = make(map[string]game.Nation)
	delete(game.ancestries)
	game.ancestries = make(map[string]game.Ancestry)
	delete(game.cultures)
	game.cultures   = make(map[string]game.Culture)
	delete(game.religions)
	game.religions  = make(map[string]game.Religion)
	delete(game.terrains)
	game.terrains   = make(map[string]game.Terrain)
}