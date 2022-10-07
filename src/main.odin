package main


//= Main
main :: proc() {

	main_initialization()
	defer main_free()

	main_loop()

}