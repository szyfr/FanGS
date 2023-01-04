package graphics


//= Imports
import "vendor:raylib"


//= Global
general_textbox        : raylib.Texture2D
general_textbox_small  : raylib.Texture2D
general_textbox_npatch : raylib.NPatchInfo

font : raylib.Font


//= Procedures
init :: proc() {
	general_textbox       = raylib.LoadTexture("data/gfx/textbox.png")
	general_textbox_small = raylib.LoadTexture("data/gfx/textbox_small.png")
	general_textbox_npatch.source =  raylib.Rectangle{0,0,48,48}
	general_textbox_npatch.left   =  16
	general_textbox_npatch.top    =  16
	general_textbox_npatch.right  =  16
	general_textbox_npatch.bottom =  16
	general_textbox_npatch.layout = .NINE_PATCH

	font = raylib.LoadFont("data/gfx/kong.ttf")
}

close :: proc() {
	raylib.UnloadTexture(general_textbox)
	raylib.UnloadTexture(general_textbox_small)
	raylib.UnloadFont(font)
}