package main



//= Imports
import "raylib"


//= Constants

//= Global Variables
graphics: ^Graphics;


//= Structures
Graphics :: struct {
	box:        raylib.Texture,
	box_nPatch: raylib.N_Patch_Info,

	font: raylib.Font,
}


//= Enumerations

//= Procedures

init_graphics :: proc() {
	graphics = new(Graphics);

	graphics.box = raylib.load_texture("data/gfx/textbox.png");
	graphics.box_nPatch.source = raylib.Rectangle{0,0,48,48};
	graphics.box_nPatch.left   = 16;
	graphics.box_nPatch.top    = 16;
	graphics.box_nPatch.right  = 16;
	graphics.box_nPatch.bottom = 16;
	graphics.box_nPatch.layout =  0;

	graphics.font = raylib.load_font("data/gfx/kong.ttf");
}
free_graphics :: proc() {
	raylib.unload_texture(graphics.box);

	free(graphics);
}

draw_button :: proc(rect: raylib.Rectangle, str: cstring) {
	raylib.draw_texture_n_patch(
		graphics.box,
		graphics.box_nPatch,
		rect,
		raylib.Vector2{0,0}, 0,
		raylib.WHITE);

	size: f32 = 16;

	textPosition: raylib.Vector2;
	textPosition.x = ((f32(rect.width) / 2) - ((size * f32(len(str))) / 2)) + rect.x;
	textPosition.y = ((f32(rect.height) / 2) - size/2) + rect.y;

	raylib.draw_text_ex(graphics.font, str, textPosition,size,1,raylib.BLACK);
}