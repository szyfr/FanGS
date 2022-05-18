package player
///=-------------------=///
//  Written: 2022/05/14  //
//  Edited:  2022/05/14  //
///=-------------------=///



import rl "../../raylib"


/// Global Player variable
player_user: ^Player;


/// Constants
FovyMinimum : f32 :  4;
FovyMaximum : f32 : 20;


// Structures
// Player
Player :: struct {
	camera: rl.Camera3d,

};