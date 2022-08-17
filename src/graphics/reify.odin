package graphics


//= Imports
import "../raylib"

import "../gamedata"


//= Procedures
init :: proc() {
	using gamedata

	graphicsdata = new(gamedata.GraphicsData)

	graphicsdata.box = raylib.load_texture("data/gfx/textbox.png")
	graphicsdata.box_nPatch.source = raylib.Rectangle{0,0,48,48}
	graphicsdata.box_nPatch.left   = 16
	graphicsdata.box_nPatch.top    = 16
	graphicsdata.box_nPatch.right  = 16
	graphicsdata.box_nPatch.bottom = 16
	graphicsdata.box_nPatch.layout =  0

	graphicsdata.font = raylib.load_font("data/gfx/kong.ttf")
}
free_data :: proc() {
	raylib.unload_texture(gamedata.graphicsdata.box)

	free(gamedata.graphicsdata)
}