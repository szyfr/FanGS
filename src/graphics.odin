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