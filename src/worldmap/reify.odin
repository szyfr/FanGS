package worldmap


//= Imports
import "core:fmt"
import "core:strings"
import "core:mem"
import "vendor:raylib"

import "../gamedata"


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

	for i:=0;i<int(mapdata.provinceImage.width * mapdata.provinceImage.height);i+=1 {
//		posX, posY := i32(i)%mapdata.provinceImage.width, i32(i)/mapdata.provinceImage.width
//		color := raylib.GetImageColor(
//			mapdata.provinceImage,
//			posX, posY,
//		)
//		if !(color in mapdata.provinces) {
//			// Add Province
//			fmt.printf("Added: pos:%i,%i (%i,%i,%i,%i)\n",
//				posX, posY,
//				color.r, color.g, color.b, color.a,
//			)
//		}
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