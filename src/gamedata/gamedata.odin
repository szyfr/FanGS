package gamedata


//= Imports
import "../raylib"

import "../worldmap"


//= Global Variables
settingsdata     : ^SettingsData
localizationdata : ^LocalizationData
graphicsdata     : ^GraphicsData

playerdata       : ^PlayerData
mapdata          : ^worldmap.MapData

elements         : map[int]rawptr


titleScreen      : bool
selectedMap      : string
abort            : bool