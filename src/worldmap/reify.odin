package worldmap


//= Imports
import "core:fmt"
import "core:math/linalg"
import "core:os"
import "core:strings"

import "vendor:raylib"

import "../localization"
import "../gamedata"
import "../settings"
import "../utilities/colors"
import "../utilities/matrix_math"


//= Procedures
init :: proc(name : string) {
	using gamedata, raylib

	worlddata = new(WorldData)

	//* Generate location strings
	provLoc := strings.concatenate({"data/mods/", name, "/map/provincemap.png"})
	terrLoc := strings.concatenate({"data/mods/", name, "/map/terrainmap.png"})

	//* Load images
	worlddata.provinceImage = LoadImage(strings.clone_to_cstring(provLoc))
	worlddata.terrainImage  = LoadImage(strings.clone_to_cstring(terrLoc))
	worlddata.provincePixelCount = int(worlddata.provinceImage.height * worlddata.provinceImage.width)

	//* Load Provinces
	provDataLoc   := strings.concatenate({"data/mods/", name, "/map/provinces.bin"})
	provData, res := os.read_entire_file(provDataLoc)
	offset        : u32 = 0

	//* Load Pops
	popDataLoc   := strings.concatenate({"data/mods/", name, "/map/pops.bin"})
	popData, res := os.read_entire_file(popDataLoc)

	//* General data
	worlddata.mapWidth  = f32(worlddata.provinceImage.width)  / 25
	worlddata.mapHeight = f32(worlddata.provinceImage.height) / 25

	//* Time
	// TODO: load date from settings
	worlddata.date = {1444, 11, 11}
	worlddata.timeSpeed = 1
	worlddata.timeDelay = 0
	worlddata.timePause = true

	//* Collision mesh
	worlddata.collisionMesh = GenMeshPlane(
		worlddata.mapWidth,
		worlddata.mapHeight,
		1, 1,
	)
	
	colTest : Color

	for i:=0; i<len(provData)/48; i+=1 {
		prov : ProvinceData = {}

		prov.localID  = u32(settings.fuse_i32(provData, offset+0))
		prov.color    = {provData[offset+4], provData[offset+5], provData[offset+6], provData[offset+7]}
		prov.terrain  = Terrain(settings.fuse_i32(provData, offset+8))
		prov.provType = ProvinceType(settings.fuse_i32(provData, offset+12))
		prov.maxInfrastructure = settings.fuse_i16(provData, offset+16)
		prov.curInfrastructure = settings.fuse_i16(provData, offset+18)
		prov.buildings[0] = provData[offset+20]
		prov.buildings[1] = provData[offset+21]
		prov.buildings[2] = provData[offset+22]
		prov.buildings[3] = provData[offset+23]
		prov.buildings[4] = provData[offset+24]
		prov.buildings[5] = provData[offset+25]
		prov.buildings[6] = provData[offset+26]
		prov.buildings[7] = provData[offset+27]

		// TODO: Province Pops / Modifiers

		//* Generate images
		width  : int = int(gamedata.worlddata.provinceImage.width)
		height : int = int(gamedata.worlddata.provinceImage.height)

		minX, maxX : f32 = f32(width),  0
		minY, maxY : f32 = f32(height), 0
		for i:=0;i<gamedata.worlddata.provincePixelCount;i+=1 {
			col := GetImageColor(
				gamedata.worlddata.provinceImage,
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

		rect : Rectangle = {minX, minY, prov.width, prov.height}
		prov.provImage   =  ImageFromImage(gamedata.worlddata.provinceImage, rect)
		// TODO: Temp. Still need to remove other colors and add border
		ImageAlphaMask(&prov.provImage, generate_alpha_mask(&prov.provImage,prov.color))
		remove_colors(&prov.provImage, prov.color)
		apply_borders(&prov.provImage)
		prov.currenttx   =  LoadTextureFromImage(prov.provImage)
		// TODO: Test to see if it needs to by scaled
		prov.provmesh    =  GenMeshPlane(prov.width / mod, prov.height / mod, 1, 1)
		prov.provmodel   =  LoadModelFromMesh(prov.provmesh)
		SetMaterialTexture(&prov.provmodel.materials[0], .ALBEDO, prov.currenttx)



		//* Finish up
		gamedata.worlddata.provincesdata[prov.color] = prov
		append(&gamedata.worlddata.provincescolor, prov.color)

		offset += 48
	}

	//* Load localization
	localization.load_mod(name)

	//* Load settings
	mapSettingsLoc    := strings.concatenate({"data/mods/", name, "/settings.bin"})
	mapSettings, resu := os.read_entire_file(mapSettingsLoc)

	gamedata.worlddata.mapsettings = new(MapSettingsData)
	gamedata.worlddata.mapsettings.loopMap = bool(mapSettings[0])
}