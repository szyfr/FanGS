package gamedata


//= Imports
import "../raylib"


//= Global Variables
settingsdata     : ^SettingsData
localizationdata : ^LocalizationData
graphicsdata     : ^GraphicsData

playerdata       : ^PlayerData
mapdata          : ^MapData

elements         : map[int]rawptr


titleScreen      : bool
selectedMap      : string
abort            : bool