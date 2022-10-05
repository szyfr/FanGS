package gamedata


//= Imports
import "vendor:raylib"


//= Structure
Population :: struct {
	pop      : u32,
	ancestry : u8,
	culture  : u8,
	religion : u8,
	unknown  : u8,
}


//= Notes
/*
	null,
	human,
	orc,
	half_orc,
	elf,
	half_elf,
	dwarf,
	halfling,
	gnome,
	harimari,
	gnoll,
	harpy,
	satyr,
	centaur,
	goblin,
	kobold,
	troll,
	ogre,
	ruinborn_elf,             //TODO: Seperate
	ruinborn_elf_degenerated, //TODO: Seperate
*/