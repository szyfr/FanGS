package worldmap
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import rl "../../raylib"


/// Global Player variable
worldmap : ^WorldMap;


/// Constants


// Structures
Chunk :: struct {
	location: rl.Vector3,
	mesh:     rl.Mesh,
	model:    rl.Model,
	texture:  rl.Texture,
};
WorldMap :: struct {
	provincesImg:   rl.Image,
	terrainImg:     rl.Image,
	numberOfChunks: u32,
	chunks:         [dynamic]Chunk,
	//provinces: Provinces,

	chunkWidth, chunkHeight: u32,
	edge: f32,
};