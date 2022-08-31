package worldmap


//= Imports
import "core:fmt"
import "core:math/linalg"
import "core:mem"
import "core:os"
import "core:strings"
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

		//	base : linalg.Matrix4x4f32 = {
		//		1, 0, 0, f32(o)*.001,
		//		0, 1, 0,         0,
		//		0, 0, 1, f32(i)*.001,
		//		0, 0, 0,         1,
		//	}
			base : linalg.Matrix4x4f32 = {
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				f32(o)*10, 0, f32(i)*10, 1,
			}
			base = mat_mult(base,MAT_ROTATE)
			base = mat_mult(base,MAT_SCALE)

			//* Location
			chunk.transform = base
		//	fmt.printf("%v,\t%v,\t%v,\t%v\n%v,\t%v,\t%v,\t%v\n%v,\t%v,\t%v,\t%v\n%v,\t%v,\t%v,\t%v\n\n",
		//		chunk.transform[0,0],chunk.transform[0,1],chunk.transform[0,2],chunk.transform[0,3],
		//		chunk.transform[1,0],chunk.transform[1,1],chunk.transform[1,2],chunk.transform[1,3],
		//		chunk.transform[2,0],chunk.transform[2,1],chunk.transform[2,2],chunk.transform[2,3],
		//		chunk.transform[3,0],chunk.transform[3,1],chunk.transform[3,2],chunk.transform[3,3],
		//	)

			//* Texture
			img   := raylib.ImageFromImage(
				mapdata.provinceImage,
				{f32(o*250),f32(i*250) , 250,250},
			)
			chunk.texture = raylib.LoadTextureFromImage(img)
			raylib.UnloadImage(img)

			//* Mesh and Model
			img = raylib.ImageCopy(mapdata.heightImage)
		//	raylib.ImageCrop(
		//		&img,
		//		{f32(o*250), f32(i*250), 251, 251},
		//	)
			raylib.ImageCrop(
				&img,
				{f32(o)*62.5, f32(i)*62.5, 63, 63},
			)
			chunk.mesh  = raylib.GenMeshHeightmap(img, {10.2, 0.2, 10.2})
			chunk.mat   = raylib.LoadMaterialDefault()
			raylib.SetMaterialTexture(&chunk.mat, .ALBEDO, chunk.texture)

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

/*   ,0   ,1   ,2   ,3
0,	 mo,  m1,  m2,  m3,
1,	 m4,  m5,  m6,  m7,
2,	 m8,  m9, m10, m11,
3,	m12, m13, m14, m15,
*/


mat_mult :: proc(
	left  : linalg.Matrix4x4f32,
	right : linalg.Matrix4x4f32,
) -> linalg.Matrix4x4f32 {
	result : linalg.Matrix4x4f32 = {}

	result[0,0] = left[0,0]*right[0,0] + left[0,1]*right[1,0] + left[0,2]*right[2,0] + left[0,3]*right[3,0]
	result[0,1] = left[0,0]*right[0,1] + left[0,1]*right[1,1] + left[0,2]*right[2,1] + left[0,3]*right[3,1]
	result[0,2] = left[0,0]*right[0,2] + left[0,1]*right[1,2] + left[0,2]*right[2,2] + left[0,3]*right[3,2]
	result[0,3] = left[0,0]*right[0,3] + left[0,1]*right[1,3] + left[0,2]*right[2,3] + left[0,3]*right[3,3]
	
	result[1,0] = left[1,0]*right[0,0] + left[1,1]*right[1,0] + left[1,2]*right[2,0] + left[1,3]*right[3,0]
	result[1,1] = left[1,0]*right[0,1] + left[1,1]*right[1,1] + left[1,2]*right[2,1] + left[1,3]*right[3,1]
	result[1,2] = left[1,0]*right[0,2] + left[1,1]*right[1,2] + left[1,2]*right[2,2] + left[1,3]*right[3,2]
	result[1,3] = left[1,0]*right[0,3] + left[1,1]*right[1,3] + left[1,2]*right[2,3] + left[1,3]*right[3,3]
	
	result[2,0] = left[2,0]*right[0,0] + left[2,1]*right[1,0] + left[2,2]*right[2,0] + left[2,3]*right[3,0]
	result[2,1] = left[2,0]*right[0,1] + left[2,1]*right[1,1] + left[2,2]*right[2,1] + left[2,3]*right[3,1]
	result[2,2] = left[2,0]*right[0,2] + left[2,1]*right[1,2] + left[2,2]*right[2,2] + left[2,3]*right[3,2]
	result[2,3] = left[2,0]*right[0,3] + left[2,1]*right[1,3] + left[2,2]*right[2,3] + left[2,3]*right[3,3]
	
	result[3,0] = left[3,0]*right[0,0] + left[3,1]*right[1,0] + left[3,2]*right[2,0] + left[3,3]*right[3,0]
	result[3,1] = left[3,0]*right[0,1] + left[3,1]*right[1,1] + left[3,2]*right[2,1] + left[3,3]*right[3,1]
	result[3,2] = left[3,0]*right[0,2] + left[3,1]*right[1,2] + left[3,2]*right[2,2] + left[3,3]*right[3,2]
	result[3,3] = left[3,0]*right[0,3] + left[3,1]*right[1,3] + left[3,2]*right[2,3] + left[3,3]*right[3,3]

	return result
}