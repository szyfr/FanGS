package graphics


//= Imports
import "../raylib"


//= Procedures
init :: proc() -> ^GraphicsData {
	graphics := new(GraphicsData)

	graphics.box = raylib.load_texture("data/gfx/textbox.png")
	graphics.box_nPatch.source = raylib.Rectangle{0,0,48,48}
	graphics.box_nPatch.left   = 16
	graphics.box_nPatch.top    = 16
	graphics.box_nPatch.right  = 16
	graphics.box_nPatch.bottom = 16
	graphics.box_nPatch.layout =  0

	graphics.font = raylib.load_font("data/gfx/kong.ttf")

	return graphics
}
free_data :: proc(graphics : ^GraphicsData) {
	raylib.unload_texture(graphics.box)

	free(graphics)
}