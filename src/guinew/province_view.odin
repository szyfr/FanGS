package guinew


//= Imports
import "core:fmt"
import "core:strings"
import "vendor:raylib"

import "../gamedata"


//= Procedures
draw_province_view :: proc() {
	topLeft := raylib.Vector2{0, f32(gamedata.settingsdata.windowHeight) - 400}

	raylib.DrawTextureNPatch(
		gamedata.graphicsdata.box,
		gamedata.graphicsdata.box_nPatch,
		{topLeft.x, topLeft.y, 300, 400},
		{0,0}, 0,
		raylib.RAYWHITE,
	)

	//* DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint)
	//* Province name
	raylib.DrawTextEx(
		gamedata.graphicsdata.font,
		gamedata.localizationdata.provincesLocalArray[int(gamedata.playerdata.currentSelection.localID)],
		{topLeft.x + 20, topLeft.y + 20},
		gamedata.settingsdata.fontSize, 0,
		raylib.BLACK,
	)

	//* Terrain and type
	raylib.DrawTextEx(
		gamedata.graphicsdata.font,
		gamedata.localizationdata.terrainLocalArray[int(gamedata.playerdata.currentSelection.terrain)],
		{topLeft.x + 40, topLeft.y + 40},
		gamedata.settingsdata.fontSize, 0,
		raylib.BLACK,
	)
	raylib.DrawTextEx(
		gamedata.graphicsdata.font,
		gamedata.localizationdata.provTypes[int(gamedata.playerdata.currentSelection.provType)],
		{topLeft.x + 40, topLeft.y + 60},
		gamedata.settingsdata.fontSize, 0,
		raylib.BLACK,
	)

	//* Infrastructure
	builder : strings.Builder = strings.Builder{buf=make([dynamic]byte, 0, 200)}
	str     := fmt.sbprintf(
		&builder,
		"%v / %v",
		gamedata.playerdata.currentSelection.curInfrastructure,
		gamedata.playerdata.currentSelection.maxInfrastructure,
	)
	raylib.DrawTextEx(
		gamedata.graphicsdata.font,
		strings.clone_to_cstring(str),
		{topLeft.x + 40, topLeft.y + 80},
		gamedata.settingsdata.fontSize, 0,
		raylib.BLACK,
	)
	clear(&builder.buf)

	//* Populations
	if gamedata.playerdata.currentSelection.provType == .base {
		str = fmt.sbprintf(
			&builder,
			"%v | %v - %v - %v\n",
			gamedata.playerdata.currentSelection.avePop.pop,
			gamedata.playerdata.currentSelection.avePop.ancestry,
			gamedata.playerdata.currentSelection.avePop.culture,
			gamedata.playerdata.currentSelection.avePop.religion,
		)
		raylib.DrawTextEx(
			gamedata.graphicsdata.font,
			strings.clone_to_cstring(str),
			{topLeft.x + 20, topLeft.y + 120},
			gamedata.settingsdata.fontSize, 0,
			raylib.BLACK,
		)
	}
	
	delete(str)
}

/*
	Old
	int(gamedata.playerdata.currentSelection.localID)+9
	int(gamedata.playerdata.currentSelection.terrain)+29
*/