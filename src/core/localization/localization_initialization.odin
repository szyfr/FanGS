package localization
///=-------------------=///
//  Written: 2022/05/16  //
//  Edited:  2022/05/16  //
///=-------------------=///



import rl "../../raylib"


/// 
init_localization :: proc() {
	localization = new(Localization);

	localization.coreLocalization = localization_creation_core();
}