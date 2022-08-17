package gui


//= Imports
import "../raylib"

import "../gamedata"


//= Procedures

//* Reification
init :: proc() {
	using gamedata

	guidata = new(gamedata.GuiData);
	guidata.abort = false
}
free_data :: proc() {
	using gamedata

	delete(guidata.elements)
	free(guidata)
}
