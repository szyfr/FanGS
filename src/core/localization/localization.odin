package localization
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import rl "../../raylib"


/// Global Player variable
localization : ^Localization;


/// Constants


// Enums
CoreLocalization :: enum{
	NEW_GAME,
	OPTIONS,
	QUIT,
	FULLLSCREEN,
	MAP_DETAIL_LEVEL,
	MAP_DETAIL_MIN,
	MAP_DETAIL_MAX,
	APPLY_SETTINGS,
	EXIT,
	RESUME,
	SAVE,
	LOAD,
	DEBUG_LOGGING,
	MAIN_MENU,
};


// Structures
Localization :: struct {
	coreLocalization: [dynamic]string,
	mapLocalization:  [dynamic]string,
};