package worldmap


//= Imports
import "core:fmt"
import "core:strings"

import "../raylib"

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
	mapdata.provinceImage = raylib.load_image(strings.clone_to_cstring(provLoc))
	mapdata.terrainImage  = raylib.load_image(strings.clone_to_cstring(terrLoc))
	mapdata.heightImage   = raylib.load_image(strings.clone_to_cstring(heigLoc))

	//* Create Chunks
	numChunksWide  := mapdata.provinceImage.width  / 250
	numChunksTall  := mapdata.provinceImage.height / 250
	numChunksTotal := numChunksWide * numChunksTall

	for i:=0;i<int(numChunksTall);i+=1 {
		for o:=0;o<int(numChunksWide);o+=1 {
			//* Location
			chunk := MapChunk{ location={-f32(o)*10,0,-f32(i)*10} }

			//* Texture
			img   := raylib.image_from_image(
				mapdata.provinceImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.texture = raylib.load_texture_from_image(img)
			raylib.unload_image(img)

			//*Mesh and Model
			img = raylib.image_from_image(
				mapdata.heightImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.mesh  = raylib.gen_mesh_heightmap(img, {1, 0.2, 1})
			chunk.model = raylib.load_model_from_mesh(chunk.mesh)
			raylib.set_material_texture(chunk.model.materials, .MATERIAL_MAP_ALBEDO,chunk.texture)

			//* Free
			raylib.unload_image(img)

			//* Save
			append(&mapdata.chunks, chunk)
		}
	}
}

free_data :: proc() {
	using gamedata

	raylib.unload_image(mapdata.provinceImage)
	raylib.unload_image(mapdata.terrainImage)
	raylib.unload_image(mapdata.heightImage)

	delete(mapdata.chunks)

	// TODO: Provinces

	free(mapdata)
	mapdata = nil
}