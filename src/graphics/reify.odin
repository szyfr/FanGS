package graphics


//= Imports
import "vendor:raylib"

import "../gamedata"


//= Procedures
init :: proc() {
	using gamedata

	graphicsdata = new(gamedata.GraphicsData)

	graphicsdata.box       = raylib.LoadTexture("data/gfx/textbox.png")
	graphicsdata.box_small = raylib.LoadTexture("data/gfx/textbox_small.png")
	graphicsdata.box_nPatch.source =  raylib.Rectangle{0,0,48,48}
	graphicsdata.box_nPatch.left   =  16
	graphicsdata.box_nPatch.top    =  16
	graphicsdata.box_nPatch.right  =  16
	graphicsdata.box_nPatch.bottom =  16
	graphicsdata.box_nPatch.layout = .NINE_PATCH

	graphicsdata.font = raylib.LoadFont("data/gfx/kong.ttf")
}
free_data :: proc() {
	raylib.UnloadTexture(gamedata.graphicsdata.box)

	free(gamedata.graphicsdata)
}