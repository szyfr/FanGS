package worldmap


//= Imports
import "core:fmt"
import "core:math/linalg"
import "core:mem"
import "core:os"
import "core:strings"
import "vendor:raylib"

import "../localization"
import "../gamedata"
import "../settings"
import "../utilities/matrix_math"


//= Procedures
//TODO: Clean up this function
init :: proc(name : string) {
	using gamedata

	mapdata = new(MapData)

	//* Generate location strings
	provLoc := strings.concatenate({"data/mods/", name, "/map/provincemap.png"})
	terrLoc := strings.concatenate({"data/mods/", name, "/map/terrainmap.png"})
	heigLoc := strings.concatenate({"data/mods/", name, "/map/heightmap.png"})

	//* Load images
	mapdata.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	mapdata.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))

	hm := raylib.LoadImage(strings.clone_to_cstring(heigLoc))
	width  := hm.width
	height := hm.height
	raylib.ImageResize(
		&hm,
		width / 4,
		height / 4,
	)
	mapdata.heightImage = raylib.ImageCopy(hm)
	

	//* Create Chunks
	numChunksWide  := mapdata.provinceImage.width  / 250
	numChunksTall  := mapdata.provinceImage.height / 250
	numChunksTotal := numChunksWide * numChunksTall

	for i:=0;i<int(numChunksTall);i+=1 {
		for o:=0;o<int(numChunksWide);o+=1 {
			chunk : MapChunk = {}

			//* Transform
			base : linalg.Matrix4x4f32 = {
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				f32(o)*10, 0, f32(i)*10, 1,
			}
			base = matrix_math.mat_mult(base,MAT_ROTATE)
			base = matrix_math.mat_mult(base,MAT_SCALE)
			chunk.transform = base

			//* Texture
			img   := raylib.ImageFromImage(
				mapdata.provinceImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.texture = raylib.LoadTextureFromImage(img)
			raylib.UnloadImage(img)

			//* Mesh
			img = raylib.ImageCopy(mapdata.heightImage)
			raylib.ImageCrop(
				&img,
				{f32(o)*62.5, f32(i)*62.5, 63, 63},
			)
			chunk.mesh  = raylib.GenMeshHeightmap(img, {10.17, 0.2, 10.17})
			chunk.mat   = raylib.LoadMaterialDefault()
			raylib.SetMaterialTexture(&chunk.mat, .ALBEDO, chunk.texture)

			//* Free
			raylib.UnloadImage(img)

			//* Save
			append(&mapdata.chunks, chunk)
		}
	}

	//* Save height and width
	mapdata.height = -(10 * numChunksTall)
	mapdata.width  = -(10 * numChunksWide)

	//* Load Provinces
	provDataLoc   := strings.concatenate({"data/mods/", name, "/map/provinces.bin"})
	provData, res := os.read_entire_file(provDataLoc)
	offset        : u32 = 0
	
	colTest : raylib.Color

	for i:=0; i<len(provData)/48; i+=1 {
		prov : Province = {}

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

		//* Generate borders
		prov.borderPoints = generate_borders(prov.color)
	//	test := 0
	//	for i:=0;i<len(prov.borderPoints);i+=1 {
	//		if prov.borderPoints[i].next.pos.x < 0 do test+=1
	//		fmt.printf(
	//			"Positions: C(%v,%v,%v) ? P(%v,%v,%v)\n",
	//			prov.borderPoints[i].pos.x,prov.borderPoints[i].pos.y,prov.borderPoints[i].pos.z,
	//			prov.borderPoints[prov.borderPoints[i].idNext].pos.x,prov.borderPoints[prov.borderPoints[i].idNext].pos.y,prov.borderPoints[prov.borderPoints[i].idNext].pos.z,
	//		//	prov.borderPoints[i].next.pos.x,prov.borderPoints[i].next.pos.y,prov.borderPoints[i].next.pos.z,
	//		)
	//	}
	//	fmt.printf("%v/%v points fucked up\n",test,len(prov.borderPoints))
		append(&mapdata.provColors, prov.color)
		
		mapdata.provinces[prov.color] = prov

		offset += 48
	}

	//* Load localization
	localization.load_mod(name)

	//* Load settings
	mapSettingsLoc    := strings.concatenate({"data/mods/", name, "/settings.bin"})
	mapSettings, resu := os.read_entire_file(mapSettingsLoc)

	mapdata.mapsettings = new(MapSettingsData)
	mapdata.mapsettings.loopMap = bool(mapSettings[0])
}

free_data :: proc() {
	using gamedata

	raylib.UnloadImage(mapdata.provinceImage)
	raylib.UnloadImage(mapdata.terrainImage)
	raylib.UnloadImage(mapdata.heightImage)

	delete(mapdata.chunks)

	delete(mapdata.provinces)

	free(mapdata)
	mapdata = nil
}