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
import "../../game/provinces"
import "../../utilities/colors"


//= Constants
MAP_PREFIX           :: "data/mods/"
MAPSETTING_LOCATION  :: "/settings.json"
MAPLOCAL_LOCATION    :: "/localization/"
MAPLOCAL_ENDING      :: ".json"
MAPPROVINCE_LOCATION :: "/map/provinces.json"
PROVINCE_LOCATION    :: "/map/provincemap.png"
TERRAIN_LOCATION     :: "/map/terrainmap.png"

ERR_MAPSETTINGS_FIND :: "[ERROR]:\tFailed to find Map Settings file."
ERR_MAPLOCAL_FIND    :: "[ERROR]:\tFailed to find Map Localization file."
ERR_MAPPROVINCES_FIND:: "[ERROR]:\tFailed to find Map Provinces file."


//= Procedures
init :: proc(mapname : string) {
	data = new(WorldMapData)

	//* Generate location strings
	provLoc := strings.concatenate({MAP_PREFIX, mapname, PROVINCE_LOCATION})
	terrLoc := strings.concatenate({MAP_PREFIX, mapname, TERRAIN_LOCATION})

	//* Load images
	data.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	data.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))
	data.provincePixelCount = int(data.provinceImage.height * data.provinceImage.width)
	
	//* Collision Mesh
	data.collisionMesh = raylib.GenMeshPlane(
		data.mapWidth,
		data.mapHeight,
		1, 1,
	)

	//* Load settings
	settingsLoc := strings.concatenate({MAP_PREFIX, mapname, MAPSETTING_LOCATION})
	if !os.is_file(settingsLoc) {
		debug.add_to_log(ERR_MAPSETTINGS_FIND)
		game.mainMenu = true
		//TODO: Add in onscreen error message
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

	//* General data
	data.mapWidth  = f32(data.provinceImage.width)  / 25
	data.mapHeight = f32(data.provinceImage.height) / 25

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
	//TODO: Redo ancestries to allow information to be put through. eg favored terrains.
	ancestryObj := jsonData.(json.Object)["ancestry"].(json.Object)
	for obj in ancestryObj {
		localization.data[obj] = strings.clone_to_cstring(ancestryObj[obj].(string))
		anc : population.Ancestry = {
			name = &localization.data[obj],
		}
		data.ancestryList[obj] = anc
	}

	//* Culture
	cultureObj := jsonData.(json.Object)["culture"].(json.Object)
	for obj in cultureObj {
		anc := &data.ancestryList[obj]

		for objc in cultureObj[obj].(json.Object) {
			localization.data[objc] = strings.clone_to_cstring(cultureObj[obj].(json.Object)[objc].(string))
			cul : population.Culture = {
				name = &localization.data[objc],
				ancestry = anc,
			}
			data.cultureList[objc] = cul
		}
	}
	
	//* Religion
	//TODO: Redo religion to allow information to be put through. eg mechanics.
	religionObj := jsonData.(json.Object)["religion"].(json.Object)
	for obj in religionObj {
		localization.data[obj] = strings.clone_to_cstring(religionObj[obj].(string))
		rel : population.Religion = {
			name = &localization.data[obj],
		}
		data.religionList[obj] = rel
	}

	//* Terrains
	//TODO: Redo ancestries to allow information to be put through. eg infrastructure bonuses.
	//TODO Set up actual data structure for terrain
	terrainObj := jsonData.(json.Object)["terrain"].(json.Object)
	for obj in terrainObj {
		localization.data[obj] = strings.clone_to_cstring(terrainObj[obj].(string))
	//	rel : population.Religion = {
	//		name = &localization.data[obj],
	//	}
	//	data.religionList[obj] = rel
	}

	//* Load Provinces
	mapProvincesLoc := strings.concatenate({MAP_PREFIX, mapname, MAPPROVINCE_LOCATION})
	if !os.is_file(mapProvincesLoc) {
		debug.add_to_log(ERR_MAPPROVINCES_FIND)
		return
	}
	rawData, err = os.read_entire_file_from_filename(mapProvincesLoc)
	jsonData, er = json.parse(rawData)
	
	//* Provinces
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
		//* Terrain
		//TODO Set up actual data structure for terrain
		switch provData["terrain"].(string) {
			case "grasslands": prov.terrain = provinces.Terrain.grasslands
			case "cave":       prov.terrain = provinces.Terrain.cave
			case "drow_hold":  prov.terrain = provinces.Terrain.drow_hold
		}
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

		//*TODO Population
		//*TODO Buildings
		//*TODO Modifiers
		//*TODO Nation

		//* Data
		width  : int = int(data.provinceImage.width)
		height : int = int(data.provinceImage.height)

		minX, maxX : f32 = f32(width),  0
		minY, maxY : f32 = f32(height), 0
		for i:=0;i<data.provincePixelCount;i+=1 {
			col := raylib.GetImageColor(
				data.provinceImage,
				i32(i%width), i32(i/width),
			)
			if colors.compare_colors(prov.color, col) {
				if f32(i%width) < minX do minX = f32(i%width)
				if f32(i%width) > maxX do maxX = f32(i%width)
				if f32(i/width) < minY do minY = f32(i/width)
				if f32(i/width) > maxY do maxY = f32(i/width)
			}
		}
		maxX += 1
		maxY += 1
		mod : f32 = 25
		prov.position    = {minX / mod, 0, minY / mod}
		prov.width       =  maxX-minX
		prov.height      =  maxY-minY
		prov.centerpoint = {
			(minX + (prov.width / 2)) / mod,
			0,
			(minY + (prov.height / 2)) / mod,
		}

		rect : raylib.Rectangle = {minX, minY, prov.width, prov.height}
		prov.provImage   =  raylib.ImageFromImage(data.provinceImage, rect)
		raylib.ImageAlphaMask(&prov.provImage, generate_alpha_mask(&prov.provImage,prov.color))
		remove_colors(&prov.provImage, prov.color)
		apply_borders(&prov.provImage)
		prov.currenttx   =  raylib.LoadTextureFromImage(prov.provImage)
		// TODO: Test to see if it needs to by scaled
		prov.provmesh    =  raylib.GenMeshPlane(prov.width / mod, prov.height / mod, 1, 1)
		prov.provmodel   =  raylib.LoadModelFromMesh(prov.provmesh)
		raylib.SetMaterialTexture(&prov.provmodel.materials[0], .ALBEDO, prov.currenttx)
		if prov.type != .impassable {
			img := raylib.ImageTextEx(
				graphics.font,
				localization.data[obj],
				20, 1,
				raylib.BLACK,
			)
			prov.nametx = raylib.LoadTextureFromImage(img)
		}

		data.provincesdata[prov.color] = prov
	}



	//for i:=0;i<len();i+=1 {}

	//*TODO Load Nations


}

//* Generates an alpha mask
//TODO Look at moving this
generate_alpha_mask :: proc(
	image : ^raylib.Image,
	color : raylib.Color,
) -> raylib.Image {
	img := raylib.ImageCopy(image^)

	for i:=0;i<int(image.width*image.height);i+=1 {
		col := raylib.GetImageColor(
			img,
			i32(i)%img.width, i32(i)/img.width,
		)
		if colors.compare_colors(color, col) {
			raylib.ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{255,255,255,255},
			)
		} else {
			raylib.ImageDrawPixel(
				&img,
				i32(i)%img.width, i32(i)/img.width,
				{0,0,0,0},
			)
		}
	}

	return img
}

//* Generates border around image
//TODO Look at moving this
apply_borders :: proc(
	image : ^raylib.Image,
) {
	collect_points(image)
	//collect_points(image)
}

//* Clears province color to white
//TODO Look at moving this
remove_colors :: proc(
	image : ^raylib.Image,
	color :  raylib.Color,
) {
	for i:=0;i<int(image.width*image.height);i+=1 {
		col := raylib.GetImageColor(
			image^,
			i32(i)%image.width, i32(i)/image.width,
		)
		if colors.compare_colors(color, col) {
			raylib.ImageDrawPixel(
				image,
				i32(i)%image.width, i32(i)/image.width,
				raylib.WHITE,
			)
		}
	}
}

//*
//TODO Look at moving this
collect_points :: proc(
	image    : ^raylib.Image,
) {
	pixelCount := int(image.width * image.height)
	array : [dynamic]raylib.Vector2
	for i:=0;i<pixelCount;i+=1 {
		posX, posY := i32(i)%image.width, i32(i)/image.width
		col := raylib.GetImageColor(image^, posX, posY)

		if check_surrounding(image, {f32(posX),f32(posY)}) && col == raylib.WHITE {
			append(&array, raylib.Vector2{f32(posX),f32(posY)})
		}
	}
	for i:=0;i<len(array);i+=1 {
		raylib.ImageDrawPixel(	
			image,
			i32(array[i].x), i32(array[i].y),
			raylib.GRAY,
		)
	}
}

//*
//TODO Look at moving this
check_surrounding :: proc(
	image    : ^raylib.Image,
	position :  raylib.Vector2,
) -> bool {
	result : bool = false
	col    : raylib.Color

	//* Edge
	if position.y == 0                 do return true
	if position.y == f32(image.height) do return true
	if position.x == 0                 do return true
	if position.x == f32(image.width)  do return true

	//* Up
	col = raylib.GetImageColor(image^, i32(position.x), i32(position.y-1))
	if col != raylib.WHITE do return true
	//* Upright
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y-1))
	if col != raylib.WHITE do return true
	//* Right
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y))
	if col != raylib.WHITE do return true
	//* Downright
	col = raylib.GetImageColor(image^, i32(position.x+1), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Down
	col = raylib.GetImageColor(image^, i32(position.x), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Downleft
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y+1))
	if col != raylib.WHITE do return true
	//* Left
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y))
	if col != raylib.WHITE do return true
	//* Upleft
	col = raylib.GetImageColor(image^, i32(position.x-1), i32(position.y-1))
	if col != raylib.WHITE do return true

	return false
}