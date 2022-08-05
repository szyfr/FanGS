package gui


//= Imports


//= Procedures
update_elements :: proc{ update_main_elements, update_sub_elements, }
update_main_elements :: proc(guidata : ^GuiData) {
	for i:=0; i<len(guidata.elements); i+=1 {
		#partial switch guidata.elements[i].type {
			case .button:
				update_button(guidata, i32(i));
				break;
			case .toggle:
				update_toggle(&guidata.elements[i]);
				break;
			case .tooltip:
				update_tooltip(&guidata.elements[i]);
				break;
			case .window:
				update_window(&guidata.elements[i], guidata, i32(i));
				break;
		}
	}
}
update_sub_elements :: proc(elements : [dynamic]Element, guidata : ^GuiData, owner : i32) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .button:
				update_button(&elements[i], guidata, owner);
				break;
			case .toggle:
				update_toggle(&elements[i]);
				break;
			case .tooltip:
				update_tooltip(&elements[i]);
				break;
		}
	}
}
draw_elements   :: proc(elements: [dynamic]Element) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .label:   draw_label(&elements[i]);   break;
			case .button:  draw_button(&elements[i]);  break;
			case .toggle:  draw_toggle(&elements[i]);  break;
			case .tooltip: draw_tooltip(&elements[i]); break;
			case .window:  draw_window(&elements[i]);  break;
		}
	}
}