package player
///=-------------------=///
//  Written: 2022/05/14  //
//  Edited:  2022/05/14  //
///=-------------------=///



import rl "../raylib"


// Init Player
init_player :: proc() {
	player_user = new(Player);

	player_user.camera.position   = rl.Vector3{13.25, 5, 4  };
	player_user.camera.target     = rl.Vector3{13.25, 0, 1.5};
	player_user.camera.up         = rl.Vector3{ 0   , 1, 0  };
	player_user.camera.fovy       = 20;
	player_user.camera.projection = rl.Camera_Projection.CAMERA_PERSPECTIVE;
}