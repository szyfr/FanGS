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

MAPPROVINCE_LOCATION :: "/map/provinces.json"
MAPNATION_LOCATION   :: "/map/nations.json"

PROVINCE_LOCATION    :: "/map/provincemap.png"
HEIGHT_LOCATION      :: "/map/provincemap.png"
TERRAIN_LOCATION     :: "/map/terrainmap.png"

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
	//* Load
	//* - Map files are loaded from each, then the last version is used
	//? - Maybe add in multiple map functionality?
	//* - Provinces
	//* - Nations

	for mod in game.mods {
		load_localization(mod)
		load_ancestries(mod)
		load_cultures(mod)
		load_religions(mod)
		load_terrain(mod)
		load_provinces(mod)
		load_nations(mod)

		//TODO Seperate into function
		game.worldmap = new(game.Worldmap)

		//* Shader //TODO Seperate this
		game.worldmap.shader = raylib.LoadShader(nil,"data/gfx/shaders/shader.fs")
		create_shader_variable("mapmode", 0)

		directory := strings.concatenate({
			MAP_PREFIX,
			strings.clone_from_cstring(mod),
			MODMAP_LOCATION,
		})
		directoryCount :i32= 0
		directoryList := raylib.GetDirectoryFiles(strings.clone_to_cstring(directory), &directoryCount)
		for i:=2;i<int(directoryCount);i+=1 {
			load_map(mod, i-2)
		}
		
		create_shader_variable("textureSize", [2]f32{game.worldmap.worlds[0].mapWidth*MAP_RESIZE, game.worldmap.worlds[0].mapHeight*MAP_RESIZE})
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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPLOCAL_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPLOCAL_PARSE))
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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPANCESTRY_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPANCESTRY_PARSE))
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

	for i in game.ancestries do fmt.printf("%v:%v\n", i, game.ancestries[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPCULTURE_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPCULTURE_PARSE))
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

	for i in game.cultures do fmt.printf("%v:%v\n", i, game.cultures[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPRELIGION_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPRELIGION_PARSE))
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

	for i in game.religions do fmt.printf("%v:%v\n", i, game.religions[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPTERRAIN_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPTERRAIN_PARSE))
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

	for i in game.terrains do fmt.printf("%v:%v\n", i, game.terrains[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPPROVINCES_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPPROVINCES_PARSE))
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
		//*TODO Nation

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

	for i in game.provinces do fmt.printf("%v:%v\n", i, game.provinces[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPNATIONS_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MAPNATIONS_PARSE))
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
//	nations.set_all_owned_provinces()

	for i in game.nations do fmt.printf("%v:%v\n", i, game.nations[i])

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
		append(&game.errorHolder.errorArray, debug.create(ERR_MODSETTINGS_FIND))
		return false
	}
	jsondata, jsonError := json.parse(rawdata, .JSON5)
	if jsonError != .None && jsonError != .EOF {
		append(&game.errorHolder.errorArray, debug.create(ERR_MODSETTINGS_PARSE))
		delete(rawdata)
		return false
	}

	game.worldmap.settings = new(game.MapSettingsData)
	game.worldmap.settings.loopMap = jsondata.(json.Object)["loopmap"].(bool)

	game.worldmap.date.year  = uint(jsondata.(json.Object)["time"].(json.Object)["year"].(f64))
	game.worldmap.date.month = uint(jsondata.(json.Object)["time"].(json.Object)["month"].(f64))
	game.worldmap.date.day   = uint(jsondata.(json.Object)["time"].(json.Object)["day"].(f64))
	game.worldmap.timePause  = true

	fmt.printf("%v\n%v\n", game.worldmap.settings, game.worldmap.date)

	delete(rawdata)
	return true
}

load_map :: proc(filename : cstring, index : int) -> bool {
	builder : strings.Builder
	directory := strings.concatenate({
		MAP_PREFIX,
		strings.clone_from_cstring(filename),
		MODMAP_LOCATION,
		fmt.sbprint(&builder, "%v", index),
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


init :: proc(mapname : string) {
	game.worldmap = new(game.Worldmap)

	//provLoc := strings.concatenate({MAP_PREFIX, mapname, PROVINCE_LOCATION})
	//heigLoc := strings.concatenate({MAP_PREFIX, mapname, HEIGHT_LOCATION})
	//terrLoc := strings.concatenate({MAP_PREFIX, mapname, TERRAIN_LOCATION})

	world := game.worldmap.worlds[game.worldmap.activeWorld]

	////* Load images
	//world.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	//world.heightImage   = raylib.LoadImage(strings.clone_to_cstring(heigLoc))
	//world.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))

	////* General data
	//world.mapWidth  = f32(world.provinceImage.width)  / MAP_RESIZE
	//world.mapHeight = f32(world.provinceImage.height) / MAP_RESIZE

	////* Mesh / Model
	//height : raylib.Image = raylib.ImageCopy(world.heightImage)
	//raylib.ImageResize(&height, height.width/HEIGHTMAP_RESIZE, height.height/HEIGHTMAP_RESIZE)
	//world.collisionMesh = raylib.GenMeshHeightmap(height, {world.mapWidth+0.20, 0.5, world.mapHeight+0.20})
	//world.model = raylib.LoadModelFromMesh(world.collisionMesh)
	//raylib.UnloadImage(height)
	//world.model.materials[0].maps[0].texture = raylib.LoadTextureFromImage(world.provinceImage)

	////* Shader
	//game.worldmap.shader = raylib.LoadShader(nil,"data/gfx/shaders/shader.fs")
	//world.model.materials[0].shader = game.worldmap.shader

	//create_shader_variable("mapmode", 0)
	//create_shader_variable("textureSize", [2]f32{world.mapWidth*MAP_RESIZE, world.mapHeight*MAP_RESIZE})


	//* Load settings
	//settingsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPSETTING_LOCATION})
	//if !os.is_file(settingsLoc) {
	//	debug.add_to_log(ERR_MODSETTINGS_FIND)
	//	game.state = .mainmenu
	//	//TODO Add in onscreen error message
	//	return
	//}
	//rawData, err := os.read_entire_file_from_filename(settingsLoc)
	//jsonData, er := json.parse(rawData)
//
	//game.worldmap.settings = new(game.MapSettingsData)
	//game.worldmap.settings.loopMap = jsonData.(json.Object)["loopmap"].(bool)
	
	////* Load time
	//dateObj := jsonData.(json.Object)["time"].(json.Object)
	//game.worldmap.date.year  = uint(dateObj["year"].(f64))
	//game.worldmap.date.month = uint(dateObj["month"].(f64))
	//game.worldmap.date.day   = uint(dateObj["day"].(f64))
	//game.worldmap.timePause  = true

	//delete(rawData)

	//* Load mod localization
	//localizationsLoc := strings.concatenate({MAP_PREFIX, mapname, MODLOCAL_LOCATION, strings.clone_from_cstring(game.settings.language), JSON_ENDING})
	//if !os.is_file(localizationsLoc) {
	//	debug.add_to_log(ERR_MAPLOCAL_FIND)
	//	return
	//}
	//rawData, err = os.read_entire_file_from_filename(localizationsLoc)
	//jsonData, er = json.parse(rawData)

	//* Ancestry
	//ancestryObj := jsonData.(json.Object)["ancestry"].(json.Object)
	//for obj in ancestryObj {
	//	game.localization[obj] = strings.clone_to_cstring(ancestryObj[obj].(json.Object)["local"].(string))
	//	anc : game.Ancestry = {
	//		name   = &game.localization[obj],
	//		growth = f32(ancestryObj[obj].(json.Object)["growth"].(f64)),
	//		color = {
	//			u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
	//			u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
	//			u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
	//			u8(ancestryObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
	//		},
	//		// Values
	//	}
	//	game.ancestries[obj] = anc
	//}

	//* Culture
	//cultureObj := jsonData.(json.Object)["culture"].(json.Object)
	//for obj in cultureObj {
	//	anc := &game.ancestries[obj]
//
	//	for objc in cultureObj[obj].(json.Object) {
	//		game.localization[objc] = strings.clone_to_cstring(cultureObj[obj].(json.Object)[objc].(json.Object)["local"].(string))
	//		cul : game.Culture = {
	//			name = &game.localization[objc],
	//			ancestry = anc,
	//			color = {
	//				u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[0].(f64)),
	//				u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[1].(f64)),
	//				u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[2].(f64)),
	//				u8(cultureObj[obj].(json.Object)[objc].(json.Object)["color"].(json.Array)[3].(f64)),
	//			},
	//			// Values
	//		}
	//		game.cultures[objc] = cul
	//	}
	//}
	
	//* Religion
	//religionObj := jsonData.(json.Object)["religion"].(json.Object)
	//for obj in religionObj {
	//	game.localization[obj] = strings.clone_to_cstring(religionObj[obj].(json.Object)["local"].(string))
	//	rel : game.Religion = {
	//		name = &game.localization[obj],
	//		color = {
	//			u8(religionObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
	//			u8(religionObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
	//			u8(religionObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
	//			u8(religionObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
	//		},
	//		// Values
	//	}
	//	game.religions[obj] = rel
	//}

	//* Terrain
	//terrainObj := jsonData.(json.Object)["terrain"].(json.Object)
	//for obj in terrainObj {
	//	game.localization[obj] = strings.clone_to_cstring(terrainObj[obj].(json.Object)["local"].(string))
	//	ter : game.Terrain = {
	//		name  = &game.localization[obj],
	//		color = {
	//			u8(terrainObj[obj].(json.Object)["color"].(json.Array)[0].(f64)),
	//			u8(terrainObj[obj].(json.Object)["color"].(json.Array)[1].(f64)),
	//			u8(terrainObj[obj].(json.Object)["color"].(json.Array)[2].(f64)),
	//			u8(terrainObj[obj].(json.Object)["color"].(json.Array)[3].(f64)),
	//		},
	//		// Values
	//	}
	//	game.terrains[obj] = ter
	//}

	//* Province localization
	//provObj := jsonData.(json.Object)["provinces"].(json.Object)
	//for obj in provObj {
	//	game.localization[obj] = strings.clone_to_cstring(provObj[obj].(string))
	//}

	//* Nation localization
	//nationObj := jsonData.(json.Object)["nations"].(json.Object)
	//for obj in nationObj {
	//	game.localization[obj] = strings.clone_to_cstring(nationObj[obj].(string))
	//}

	//delete(rawData)

	//* Load Provinces
	mapProvincesLoc := strings.concatenate({MAP_PREFIX, mapname, MAPPROVINCE_LOCATION})
	if !os.is_file(mapProvincesLoc) {
		debug.add_to_log(ERR_MAPPROVINCES_FIND)
		return
	}
	rawData, err := os.read_entire_file_from_filename(mapProvincesLoc)
	jsonData, er := json.parse(rawData)
	
	//* Provinces
	provinceList : map[u32]raylib.Color
	for obj in jsonData.(json.Object) {
		provData := jsonData.(json.Object)[obj].(json.Object)
		value, ok := strconv.parse_u64(obj)
		prov : game.Province = {}

		//* ID number
		//TODO Names
		prov.localID = u32(value)
	//	prov.name = &game.localization[provData["name"].(string)]

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

	////* Nations
	//mapNationsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPNATION_LOCATION})
	//if !os.is_file(mapNationsLoc) {
	//	debug.add_to_log(ERR_MAPNATIONS_FIND)
	//	return
	//}
	//rawData, err = os.read_entire_file_from_filename(mapNationsLoc)
	//jsonData, er = json.parse(rawData)
//
	//for obj in jsonData.(json.Object) {
	//	nation : game.Nation = {
	//		localID = jsonData.(json.Object)[obj].(json.Object)["local"].(string),
	//		color   = {
	//			u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["r"].(f64)),
	//			u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["g"].(f64)),
	//			u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["b"].(f64)),
	//			255,
	//		},
	//		//TODO Name Texture?
	//	}
//
	//	//* Flag
	//	flaglocation := strings.clone_to_cstring(strings.concatenate({MAP_PREFIX, mapname, MAPFLAG_PREFIX, nation.localID, MAPFLAG_EXT}))
	//	nation.flag   = raylib.LoadTexture(flaglocation)
	//	delete(flaglocation)
//
	//	//* Owned provinces
	//	for prov in jsonData.(json.Object)[obj].(json.Object)["provinces"].(json.Array) {
	//		value, ok := strconv.parse_u64(prov.(string))
	//		append(&nation.ownedProvinces, provinceList[u32(value)])
	//	}
	//	
	//	//* Centerpoint
	//	nations.calculate_center(&nation)
//
	//	game.nations[nation.localID] = nation
	//}
	//nations.set_all_owned_provinces()

	delete(rawData)
}

close :: proc() {
	world := game.worldmap.worlds[game.worldmap.activeWorld]
	//* Worldmap
	raylib.UnloadImage(world.provinceImage)
	raylib.UnloadImage(world.heightImage)
	raylib.UnloadImage(world.terrainImage)
	raylib.UnloadModel(world.model)
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