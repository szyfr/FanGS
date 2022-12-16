package gamedata


//= Imports
import "vendor:raylib"


//= Global Variables
settingsdata     : ^SettingsData
localizationdata : ^LocalizationData
graphicsdata     : ^GraphicsData

playerdata       : ^PlayerData

worlddata        : ^WorldData

elements         : map[int]rawptr


titleScreen      : bool
pausemenu        : bool
optionsmenu      : bool
selectedMap      : string
abort            : bool