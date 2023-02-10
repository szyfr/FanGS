package graphics


//= Imports
import "vendor:raylib"

import "../game"


//= Procedures
init :: proc() {
	game.general_textbox       = raylib.LoadTexture("data/gfx/textbox.png")
	game.general_textbox_small = raylib.LoadTexture("data/gfx/textbox_small.png")
	game.general_textbox_npatch.source =  raylib.Rectangle{0,0,48,48}
	game.general_textbox_npatch.left   =  16
	game.general_textbox_npatch.top    =  16
	game.general_textbox_npatch.right  =  16
	game.general_textbox_npatch.bottom =  16
	game.general_textbox_npatch.layout = .NINE_PATCH

	game.font = raylib.LoadFont("data/gfx/kong.ttf")
}

close :: proc() {
	raylib.UnloadTexture(game.general_textbox)
	raylib.UnloadTexture(game.general_textbox_small)
	raylib.UnloadFont(game.font)
}