package testing


import "core:fmt"
import "../game/settings"

test :: proc() {
	fmt.printf("%v",settings.data)
}