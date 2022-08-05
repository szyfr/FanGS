package gui


//= Imports
import "../raylib"


//= Procedures

//* Reification
init :: proc() -> ^GuiData {
	gui := new(GuiData);

	return gui
}
free_data :: proc(gui : ^GuiData) {
	delete(gui.elements)

	free(gui)
}

//* Array management
delete_element :: proc(guidata : ^GuiData, index : i32) {
	array : [dynamic]Element

	for i:int=0; i<len(guidata.elements); i+=1 {
		if i != int(index) do append(&array, guidata.elements[i])
	}

	delete(guidata.elements)
	guidata.elements = array
}