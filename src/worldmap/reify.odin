package worldmap


//= Imports
import "core:fmt"
import "core:strings"
import "core:mem"
import "core:os"
import "vendor:raylib"

import "../gamedata"
import "../settings"


//= Procedures
init :: proc(name : string) {
	using gamedata

	mapdata = new(MapData)

	//* Generate location strings
	provLoc : = strings.concatenate({"data/mods/", name, "/map/provincemap.png"})
	terrLoc : = strings.concatenate({"data/mods/", name, "/map/terrainmap.png"})
	heigLoc : = strings.concatenate({"data/mods/", name, "/map/heightmap.png"})

	//* Load images
	mapdata.provinceImage = raylib.LoadImage(strings.clone_to_cstring(provLoc))
	mapdata.terrainImage  = raylib.LoadImage(strings.clone_to_cstring(terrLoc))
	mapdata.heightImage   = raylib.LoadImage(strings.clone_to_cstring(heigLoc))

	//* Create Chunks
	numChunksWide  := mapdata.provinceImage.width  / 250
	numChunksTall  := mapdata.provinceImage.height / 250
	numChunksTotal := numChunksWide * numChunksTall

	for i:=0;i<int(numChunksTall);i+=1 {
		for o:=0;o<int(numChunksWide);o+=1 {
			//* Location
			chunk := MapChunk{ location={-f32(o)*10,0,-f32(i)*10} }

			//* Texture
			img   := raylib.ImageFromImage(
				mapdata.provinceImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.texture = raylib.LoadTextureFromImage(img)
			raylib.UnloadImage(img)

			//*Mesh and Model
			img = raylib.ImageFromImage(
				mapdata.heightImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.mesh  = raylib.GenMeshHeightmap(img, {1, 0.2, 1})
			chunk.model = raylib.LoadModelFromMesh(chunk.mesh)
			raylib.SetMaterialTexture(chunk.model.materials, .ALBEDO, chunk.texture)

			//* Free
			raylib.UnloadImage(img)

			//* Save
			append(&mapdata.chunks, chunk)
		}
	}

//	size : i32 = 0
//	colors := raylib.LoadImagePalette(mapdata.provinceImage, 10000, &size)

	provDataLoc   := strings.concatenate({"data/mods/", name, "/map/provinces.bin"})
	provData, res := os.read_entire_file(provDataLoc)
	offset        : u32 = 0
	
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

	//	fmt.printf("%i: %i,%i,%i\n%i, %i\n%i/%i\n",
	//		prov.localID, prov.color.r, prov.color.g, prov.color.b,
	//		prov.terrain, prov.provType,
	//		prov.curInfrastructure, prov.maxInfrastructure,
	//	)

		mapdata.provinces[prov.color] = prov

		offset += 48
	}
}

free_data :: proc() {
	using gamedata

	raylib.UnloadImage(mapdata.provinceImage)
	raylib.UnloadImage(mapdata.terrainImage)
	raylib.UnloadImage(mapdata.heightImage)

	delete(mapdata.chunks)

	// TODO: Provinces

	free(mapdata)
	mapdata = nil
}