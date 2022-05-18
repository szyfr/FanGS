package player
///=-------------------=///
//  Written: 2022/05/14  //
//  Edited:  2022/05/14  //
///=-------------------=///



import math "core:math/linalg/glsl"
import rl   "../../raylib"


// Updates the players camera
//   Arrow keys move camera directly
//   Middle mouse button and dragging cursor drags the field of view
// TODO: Edge jumping
// TODO: z-axis clamping
update_player_camera_movement :: proc() {
	using rl;

	movementModifier: f32 = 0.065 * (player_user.camera.fovy / 20);

	// Key checking
	if is_key_down(Keyboard_Key.KEY_UP) {
		player_user.camera.target.z   -= movementModifier;
		player_user.camera.position.z -= movementModifier;
	}
	if is_key_down(Keyboard_Key.KEY_DOWN) {
		player_user.camera.target.z   += movementModifier;
		player_user.camera.position.z += movementModifier;
	}
	if is_key_down(Keyboard_Key.KEY_LEFT) {
		player_user.camera.target.x   -= movementModifier;
		player_user.camera.position.x -= movementModifier;
	}
	if is_key_down(Keyboard_Key.KEY_RIGHT) {
		player_user.camera.target.x   += movementModifier;
		player_user.camera.position.x += movementModifier;
	}

	// Checking mouse input
	mouseDelta: Vector2 = get_mouse_delta();
	if is_mouse_button_down(Mouse_Button.MOUSE_BUTTON_MIDDLE) {
		mouseDelta.x *= movementModifier / 20;
		mouseDelta.y *= movementModifier / 20;

		player_user.camera.target.x   -= mouseDelta.x;
		player_user.camera.position.x -= mouseDelta.x;
		player_user.camera.target.z   -= mouseDelta.y;
		player_user.camera.position.z -= mouseDelta.y;
	}

	// Zoom
	mouseWheel: f32 = get_mouse_wheel_move();
	if mouseWheel != 0 {
		player_user.camera.fovy -= mouseWheel / 1.5;
		player_user.camera.fovy  = math.clamp_f32(player_user.camera.fovy, FovyMinimum, FovyMaximum);
	}
}