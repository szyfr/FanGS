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
MODLOCAL_LOCATION    :: "/localization/"
MODDATA_LOCATION     :: "/common/"
MODMAP_LOCATION      :: "/maps/"
MODANCESTRY_LOCATION :: "ancestries"
MODCULTURE_LOCATION  :: "cultures"
MODRELIGION_LOCATION :: "religions"
MODTERRAIN_LOCATION  :: "terrains"
MODPROVINCES_LOCATION:: "provinces"
MODNATIONS_LOCATION  :: "nations"
JSON_ENDING          :: ".json"

MAPFLAG_PREFIX       :: "/gfx/flags/"
MAPFLAG_EXT          :: ".png"

MAPPROVINCE_LOCATION :: "/provinces.json"
MAPNATION_LOCATION   :: "/nations.json"

PROVINCE_LOCATION    :: "/provincemap.png"
HEIGHT_LOCATION      :: "/heightmap.png"
TERRAIN_LOCATION     :: "/terrainmap.png"

ERR_MAPLOCAL_FIND     :: "[ERROR]:\tFailed to find mod Localization file."
ERR_MAPLOCAL_PARSE    :: "[ERROR]:\tFailed to parse mod Localization file."
ERR_MAPANCESTRY_FIND  :: "[ERROR]:\tFailed to find mod Ancestry file."
ERR_MAPANCESTRY_PARSE :: "[ERROR]:\tFailed to parse mod Ancestry file."
ERR_MAPCULTURE_FIND   :: "[ERROR]:\tFailed to find mod Culture file."
ERR_MAPCULTURE_PARSE  :: "[ERROR]:\tFailed to parse mod Culture file."
ERR_MAPRELIGION_FIND  :: "[ERROR]:\tFailed to find mod Religion file."
ERR_MAPRELIGION_PARSE :: "[ERROR]:\tFailed to parse mod Religion file."
ERR_MAPTERRAIN_FIND   :: "[ERROR]:\tFailed to find mod Terrain file."
ERR_MAPTERRAIN_PARSE  :: "[ERROR]:\tFailed to parse mod Terrain file."
ERR_MAPPROVINCES_FIND :: "[ERROR]:\tFailed to find mod Provinces file."
ERR_MAPPROVINCES_PARSE:: "[ERROR]:\tFailed to parse mod Provinces file."
ERR_MAPNATIONS_FIND   :: "[ERROR]:\tFailed to find mod Nations file."
ERR_MAPNATIONS_PARSE  :: "[ERROR]:\tFailed to parse mod Nations file."

ERR_MODSETTINGS_FIND  :: "[ERROR]:\tFailed to find mod Settings file."
ERR_MODSETTINGS_PARSE :: "[ERROR]:\tFailed to parse mod Settings file."


//= Procedures
init_new :: proc() {
	for mod in game.mods {
		load_localization(mod)

		load_ancestries(mod)
		load_cultures(mod)
		load_religions(mod)
		load_terrain(mod)

		load_worldmap(mod)
		load_mapsettings(mod)

		load_provinces(mod)
		load_nations(mod)
	}
}

load_localization :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODLOCAL_LOCATION,
		strings.clone_from_cstring(game.settings.language),
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPLOCAL_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPLOCAL_PARSE, 1)
		delete(rawdata)
		return false
	}

	for obj in jsondata.(json.Object) {
		game.localization[obj] = strings.clone_to_cstring(jsondata.(json.Object)[obj].(string))
	}

	delete(rawdata)
	return true
}

load_ancestries :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODANCESTRY_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPANCESTRY_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPANCESTRY_PARSE, 1)
		delete(rawdata)
		return false
	}

	for obj in jsondata.(json.Object) {
		ancestry : game.Ancestry = {
			name   = &game.localization[obj],
			growth = f32(jsondata.(json.Object)[obj].(json.Object)["growth"].(f64)),
			color  = {
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Additional values
		}
		game.ancestries[obj] = ancestry
	}

	delete(rawdata)
	return true
}
load_cultures :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODCULTURE_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPCULTURE_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPCULTURE_PARSE, 1)
		delete(rawdata)
		return false
	}

	for obj in jsondata.(json.Object) {
		ancestry := &game.ancestries[obj]
		
		for cul in jsondata.(json.Object)[obj].(json.Object) {
			culture : game.Culture = {
				name		= &game.localization[cul],
				ancestry	= ancestry,
				color		= {
					u8(jsondata.(json.Object)[obj].(json.Object)[cul].(json.Object)["color"].(json.Array)[0].(f64)),
					u8(jsondata.(json.Object)[obj].(json.Object)[cul].(json.Object)["color"].(json.Array)[1].(f64)),
					u8(jsondata.(json.Object)[obj].(json.Object)[cul].(json.Object)["color"].(json.Array)[2].(f64)),
					u8(jsondata.(json.Object)[obj].(json.Object)[cul].(json.Object)["color"].(json.Array)[3].(f64)),
				},
				// Additional values
			}
			game.cultures[cul] = culture
		}
	}

	delete(rawdata)
	return true
}
load_religions :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODRELIGION_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPRELIGION_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPRELIGION_PARSE, 1)
		delete(rawdata)
		return false
	}

	for obj in jsondata.(json.Object) {
		religion : game.Religion = {
			name   = &game.localization[obj],
			color  = {
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Additional values
		}
		game.religions[obj] = religion
	}

	delete(rawdata)
	return true
}
load_terrain :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODTERRAIN_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPTERRAIN_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPTERRAIN_PARSE, 1)
		delete(rawdata)
		return false
	}

	for obj in jsondata.(json.Object) {
		terrain : game.Terrain = {
			name   = &game.localization[obj],
			color  = {
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[0].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[1].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[2].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Array)[3].(f64)),
			},
			// Additional values
		}
		game.terrains[obj] = terrain
	}

	delete(rawdata)
	return true
}
load_provinces :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODPROVINCES_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPPROVINCES_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPPROVINCES_PARSE, 1)
		delete(rawdata)
		return false
	}

	count :u32= 0
	for obj in jsondata.(json.Object) {
		province : game.Province = {
			localID	= count,
			name	= obj,
			color	= {
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["r"].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["g"].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["b"].(f64)),
				255,
			},
			
		}

		//* Terrain
		province.terrain	= &game.terrains[jsondata.(json.Object)[obj].(json.Object)["terrain"].(string)]

		//* Type
		switch jsondata.(json.Object)[obj].(json.Object)["type"].(string) {
			case "normal":       province.type = .base
			case "controllable": province.type = .controllable
			case "ocean":        province.type = .ocean
			case "lake":         province.type = .lake
			case "impassable":   province.type = .impassable
		}

		//* Infrastructure
		//TODO Remove max infrastructure and replace with calculation using terrain and mods
		province.maxInfrastructure = i16(jsondata.(json.Object)[obj].(json.Object)["max_infrastructure"].(f64))
		province.curInfrastructure = i16(jsondata.(json.Object)[obj].(json.Object)["cur_infrastructure"].(f64))

		//* Population
		popData := jsondata.(json.Object)[obj].(json.Object)["population"].(json.Array)
		for pop in popData {
			population : game.Population = {
				count = u64(pop.(json.Object)["count"].(f64)),

				ancestry = &game.ancestries[pop.(json.Object)["ancestry"].(string)],
				culture  = &game.cultures[pop.(json.Object)["culture"].(string)],
				religion = &game.religions[pop.(json.Object)["religion"].(string)],
			}
			append(&province.popList, population)
		}
		province.avePop = population.avearge_province_pop(&province)
		
		//*TODO Buildings
		//*TODO Modifiers

		//* Shader info
		shaderInfo : game.ShaderProvince = {
			baseColor = [4]f32{
				f32(province.color.r) / 255,
				f32(province.color.g) / 255,
				f32(province.color.b) / 255,
				f32(province.color.a) / 255,
			},
			mapColor = [4]f32{
				f32(province.color.r) / 255,
				f32(province.color.g) / 255,
				f32(province.color.b) / 255,
				f32(province.color.a) / 255,
			},
		}
		province.shaderIndex = int(create_shader_variable("prov", shaderInfo, province.localID))

		game.provinces[province.color] = province

		count += 1
	}

	delete(rawdata)
	return true
}
load_nations :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODDATA_LOCATION,
		MODNATIONS_LOCATION,
		JSON_ENDING,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MAPNATIONS_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MAPNATIONS_PARSE, 1)
		delete(rawdata)
		return false
	}

	provinceList : map[string]raylib.Color
	for province in game.provinces {
		provinceList[game.provinces[province].name] = province
	}

	for obj in jsondata.(json.Object) {
		nation : game.Nation = {
			localID = obj,
			color   = {
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["r"].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["g"].(f64)),
				u8(jsondata.(json.Object)[obj].(json.Object)["color"].(json.Object)["b"].(f64)),
				255,
			},
		}

		//* Flag
		flaglocation := strings.clone_to_cstring(strings.concatenate({MAP_PREFIX, strings.clone_from_cstring(filename), MAPFLAG_PREFIX, nation.localID, MAPFLAG_EXT}))
		nation.flag   = raylib.LoadTexture(flaglocation)
		delete(flaglocation)

		//* Owned provinces
		for prov in jsondata.(json.Object)[obj].(json.Object)["provinces"].(json.Array) {
			append(&nation.ownedProvinces, provinceList[prov.(string)])
		}
		game.nations[obj] = nation
	}
	nations.set_all_owned_provinces()

	delete(rawdata)
	return true
}

load_mapsettings :: proc(filename : cstring) -> bool {
	filePath := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MAPSETTING_LOCATION,
	})

	rawdata, error := os.read_entire_file(filePath)
	if !error {
		debug.create(&game.errorHolder.errorArray, ERR_MODSETTINGS_FIND, 1)
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		debug.create(&game.errorHolder.errorArray, ERR_MODSETTINGS_PARSE, 1)
		delete(rawdata)
		return false
	}

	game.worldmap.settings = new(game.MapSettingsData)
	game.worldmap.settings.loopMap = jsondata.(json.Object)["loopmap"].(bool)

	game.worldmap.date.year  = uint(jsondata.(json.Object)["time"].(json.Object)["year"].(f64))
	game.worldmap.date.month = uint(jsondata.(json.Object)["time"].(json.Object)["month"].(f64))
	game.worldmap.date.day   = uint(jsondata.(json.Object)["time"].(json.Object)["day"].(f64))
	game.worldmap.timePause  = true

	delete(rawdata)
	return true
}

load_worldmap :: proc(filename : cstring) {
	game.worldmap = new(game.Worldmap)
	game.worldmap.activeWorld = 0
	game.worldmap.shader = raylib.LoadShader(nil,"data/gfx/shaders/shader.fs")

	directory := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODMAP_LOCATION,
	})
	directoryCount :i32= 0
	directoryList := raylib.GetDirectoryFiles(strings.clone_to_cstring(directory), &directoryCount)
	for i:=2;i<int(directoryCount)-1;i+=1 {
		load_map(filename, i-2)
	}

	create_shader_variable("textureSize", [2]f32{game.worldmap.worlds[0].mapWidth*MAP_RESIZE, game.worldmap.worlds[0].mapHeight*MAP_RESIZE})
}
load_map :: proc(filename : cstring, index : int) -> bool {
	builder : strings.Builder
	directory := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODMAP_LOCATION,
		fmt.sbprint(&builder, index),
	})

	provinceImageLocation	:= strings.concatenate({directory, PROVINCE_LOCATION})
	heightmapImageLocation	:= strings.concatenate({directory, HEIGHT_LOCATION})
	terrainImageLocation	:= strings.concatenate({directory, TERRAIN_LOCATION})

	world : game.World	= {}

	//* Load images
	world.provinceImage	= raylib.LoadImage(strings.clone_to_cstring(provinceImageLocation))
	world.heightImage	= raylib.LoadImage(strings.clone_to_cstring(heightmapImageLocation))
	world.terrainImage	= raylib.LoadImage(strings.clone_to_cstring(terrainImageLocation))

	//* General data
	world.mapWidth  = f32(world.provinceImage.width)  / MAP_RESIZE
	world.mapHeight = f32(world.provinceImage.height) / MAP_RESIZE

	//* Mesh / Model
	height : raylib.Image = raylib.ImageCopy(world.heightImage)
	raylib.ImageResize(&height, height.width/HEIGHTMAP_RESIZE, height.height/HEIGHTMAP_RESIZE)
	world.collisionMesh = raylib.GenMeshHeightmap(height, {world.mapWidth+0.20, 0.5, world.mapHeight+0.20})
	world.model = raylib.LoadModelFromMesh(world.collisionMesh)
	raylib.UnloadImage(height)
	world.model.materials[0].maps[0].texture = raylib.LoadTextureFromImage(world.provinceImage)

	//* Shader
	world.model.materials[0].shader = game.worldmap.shader

	append(&game.worldmap.worlds, world)
	return true
}

close :: proc() {
	for world in game.worldmap.worlds {
		raylib.UnloadImage(world.provinceImage)
		raylib.UnloadImage(world.heightImage)
		raylib.UnloadImage(world.terrainImage)
		raylib.UnloadModel(world.model)
	}

	delete(game.worldmap.worlds)
	raylib.UnloadShader(game.worldmap.shader)
	delete(game.worldmap.shaderVarLoc)
	delete(game.worldmap.shaderVar)

	free(game.worldmap.settings)
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