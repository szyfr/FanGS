package game


//= Imports
import "vendor:raylib"


//= Structures

//* Settings
Settings :: struct {
	windowWidth   : i32,
	windowHeight  : i32,

	targetFPS     : i32,
	language      : cstring,
	edgeScrolling : bool,
	fontSize      : f32,

	keybindings   : map[string]Keybinding,
	mapmodesTool  : [10]Mapmode,
}
Keybinding :: struct {
	origin : u8,
		// 0 - Keyboard
		// 1 - Mouse
		// 2 - MouseWheel
		// 3 - Gamepad Button
		// 4 - Gamepad Axis
	key    : u32,
	valid  : bool,
}

//* Player
Player :: struct {
	using camera     : raylib.Camera3D,
	zoom             : f32,
	cameraSlope      : raylib.Vector3,
	lastMousePos     : raylib.Vector2,

	ray              :  raylib.Ray,
	currentSelection : ^Province,
	nation           : ^Nation,

	curMapmode       :  Mapmode,
}

//* Nations
Nation :: struct {
	localID        :  string,
	color          :  raylib.Color,

	flag           :  raylib.Texture2D,

	centerpoint    :  raylib.Vector3,
	nametx         :  raylib.Texture,

	ownedProvinces :  [dynamic]raylib.Color,
}

//* Provinces
Province :: struct {
	//* Map data
	//TODO Figure out how i want to do this
	nametx      : raylib.Texture,
	centerpoint : raylib.Vector3,

	//* Data
	localID : u32,
	name    : string,
	color   : raylib.Color,
	shaderIndex: int,

	terrain : ^Terrain,
	type    : ProvinceType,

	maxInfrastructure : i16,
	curInfrastructure : i16,

	popList   : [dynamic]Population,
	avePop    : Population,

	buildings : [8]u8,

	modifierList : [dynamic]ProvinceModifier,

	owner : ^Nation,
}
ProvinceModifier :: struct {
	//etc
}
Terrain :: struct {
	name  : ^cstring,
	color : raylib.Color,
}

//* People data storage
Ancestry :: struct {
	name   : ^cstring,
	growth : f32,
	color  : raylib.Color,
}
Culture :: struct {
	name     : ^cstring,
	ancestry : ^Ancestry,
	color  : raylib.Color,
}
Religion :: struct {
	name : ^cstring,
	color  : raylib.Color,
}
Population :: struct {
	count : u64,

	ancestry : ^Ancestry,
	culture  : ^Culture,
	religion : ^Religion,
}

//* Worldmap storage
Worldmap :: struct {
	//* Worlds
	worlds : [dynamic]World,
	activeWorld : int,

	//* Shader
	shader         : raylib.Shader,

	shaderVarLoc   : map[string]raylib.ShaderLocationIndex,
	shaderVar      : map[string]ShaderVariable,

	//* Data
	settings  : ^MapSettingsData,

	date      : Date,
	timeSpeed : uint,
	timeDelay : uint,
	timePause : bool,
}
World :: struct {
	//* Drawing
	provinceImage  : raylib.Image,
	heightImage    : raylib.Image,
	terrainImage   : raylib.Image,

	collisionMesh  : raylib.Mesh,
	model          : raylib.Model,
	
	mapHeight : f32,
	mapWidth  : f32,
}
MapSettingsData :: struct {
	loopMap : bool,
}
Date :: struct {
	year  : uint,
	month : uint,
	day   : uint,
}

//* Shader data
ShaderVariable :: union {
	i32,
	f32,
	[2]f32,
	[3]f32,
	[4]f32,
	[2]i32,
	[3]i32,
	[4]i32,
}
ShaderProvince :: struct {
	baseColor : ShaderVariable,
	mapColor  : ShaderVariable,
}


//= Enum
Mapmode :: enum {
	overworld,
	political,
	terrain,
	control,
	autonomy, //TODO Autonomy
	population,
	infrastructure,
	ancestry,
	culture,
	religion,
}

ProvinceType :: enum {
	NULL,
	base,
    controllable,
    ocean,
	lake,
    impassable,
}

AlertLevel :: enum {
	none,
	low,
	high,
}