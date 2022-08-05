package gui


//= Imports
import "../raylib"


//= Procedures

//* Array management
delete_element :: proc(guidata : ^GuiData, index : i32) {
	array : [dynamic]Element

	for i:int=0; i<len(guidata.elements); i+=1 {
		if i != int(index) do append(&array, guidata.elements[i])
	}

	delete(guidata.elements)
	guidata.elements = array
}
delete_all :: proc(guidata : ^GuiData) {
	array : [dynamic]Element
	delete(guidata.elements)
	guidata.elements = array
}
bring_front :: proc(guidata : ^GuiData, index : i32) {
	array : [dynamic]Element

	for i:int=0; i<len(guidata.elements); i+=1 {
		if i != int(index) do append(&array, guidata.elements[i])
	}
	append(&array, guidata.elements[index])

	delete(guidata.elements)
	guidata.elements = array
}