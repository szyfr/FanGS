package gui


//= Imports


//= Procedures
update_elements :: proc(elements: [dynamic]Element) {
	for i:=0; i<len(elements); i+=1 {
		#partial switch elements[i].type {
			case .button:
				update_button(&elements[i]);
				break;
			case .toggle:
				update_toggle(&elements[i]);
				break;
			case .tooltip:
				update_tooltip(&elements[i]);
				break;
			case .window:
				update_window(&elements[i]);
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