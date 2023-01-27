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

	data.shaderVarLoc["outlineSize"] = raylib.ShaderLocationIndex(raylib.GetShaderLocation(data.shader, "outlineSize"))
	data.shaderVarLoc["textureSize"] = raylib.ShaderLocationIndex(raylib.GetShaderLocation(data.shader, "textureSize"))
	data.shaderVarLoc["chosenProv"]  = raylib.ShaderLocationIndex(raylib.GetShaderLocation(data.shader, "chosenProv"))
	data.shaderVarLoc["zoom"]        = raylib.ShaderLocationIndex(raylib.GetShaderLocation(data.shader, "zoom"))
	
	data.shaderVar["mapmode"]     = 0
	data.shaderVar["outlineSize"] = 2.0
	data.shaderVar["textureSize"] = [2]f32{data.mapWidth*MAP_RESIZE, data.mapHeight*MAP_RESIZE}

	//TODO Create a wrapper function to simplify this into having a string input and the value to change it to
	raylib.SetShaderValue(data.shader, data.shaderVarLoc["mapmode"], &data.shaderVar["mapmode"], .INT)
	raylib.SetShaderValue(data.shader, data.shaderVarLoc["outlineSize"], &data.shaderVar["outlineSize"], .FLOAT)
	raylib.SetShaderValue(data.shader, data.shaderVarLoc["textureSize"], &data.shaderVar["textureSize"], .VEC2)

	//* Load settings
	settingsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPSETTING_LOCATION})
	if !os.is_file(settingsLoc) {
		debug.add_to_log(ERR_MAPSETTINGS_FIND)
		game.mainMenu = true
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
			// Values
		}
		data.religionList[obj] = rel
	}

	//* Terrains
	terrainObj := jsonData.(json.Object)["terrain"].(json.Object)
	for obj in terrainObj {
		localization.data[obj] = strings.clone_to_cstring(terrainObj[obj].(json.Object)["local"].(string))
		ter : provinces.Terrain = {
			name = &localization.data[obj],
			// Values
		}
		data.terrainList[obj] = ter
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
		localization.data[obj] = strings.clone_to_cstring(provData["name"].(string))
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
		//TODO: Remove max infrastructure and freplace with calculation using terrain and mods
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

		data.provincesdata[prov.color] = prov
	}

	//*TODO Nation
	mapNationsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPNATION_LOCATION})
	if !os.is_file(mapNationsLoc) {
		debug.add_to_log(ERR_MAPNATIONS_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(mapNationsLoc)
	jsonData, er = json.parse(rawData)

	for obj in jsonData.(json.Object) {
		localization.data[obj] = strings.clone_to_cstring(jsonData.(json.Object)[obj].(json.Object)["local"].(string))
		nation : nations.Nation = {
			localID = obj,
			name    = &localization.data[obj], //TODO Remove this sort of thing
			color   = {
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["r"].(f64)),
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["g"].(f64)),
				u8(jsonData.(json.Object)[obj].(json.Object)["color"].(json.Object)["b"].(f64)),
				255,
			},
			//TODO Name Texture?
		}

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