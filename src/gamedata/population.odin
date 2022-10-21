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
0	null,
1	human,
2	orc,
3	half_orc,
4	elf,
5	half_elf,
6	dwarf,
7	halfling,
8	gnome,
9	harimari,
10	gnoll,
11	harpy,
12	satyr,
13	centaur,
14	goblin,
15	kobold,
16	troll,
17	ogre,
*/