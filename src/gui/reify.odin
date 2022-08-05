package gui


//= Imports
import "../raylib"


//= Procedures

//* Reification
init :: proc() -> ^GuiData {
	gui := new(GuiData);

	gui.abort = false

	return gui
}
free_data :: proc(gui : ^GuiData) {
	delete(gui.elements)

	free(gui)
}
