package testing


import "core:fmt"
import "../settings"

test :: proc() {
	fmt.printf("%v",settings.data)
}