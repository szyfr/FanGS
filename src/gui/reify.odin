package gui


//= Imports
import "../raylib"


//= Procedures
init :: proc() -> ^GuiData {
	gui := new(GuiData);

	return gui
}
free_data :: proc(gui : ^GuiData) {
	delete(gui.elements)

	free(gui)
}