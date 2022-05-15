@echo off

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x64

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "date=%dt:~0,4%_%dt:~4,2%_%dt:~6,2%"

xcopy "data\"    "target\debug\%date%\data\" /v /q /s /e /y > nul
xcopy "src\"     "target\debug\%date%\src\"  /v /q /s /e /y > nul
xcopy "include\" "target\debug\%date%\"      /v /q /s /e /y > nul

rem ROBOCOPY "G:\FanGSOdin\data"    "G:\FanGSOdin\target\debug\%date%\data"       /mir /nfl /ndl /njh /njs /np /ns /nc > nul
rem ROBOCOPY "G:\FanGSOdin\src"     "G:\FanGSOdin\target\debug\%date%\source\src" /mir /nfl /ndl /njh /njs /np /ns /nc > nul
rem ROBOCOPY "G:\FanGSOdin\include" "G:\FanGSOdin\target\debug\%date%"            /mir /nfl /ndl /njh /njs /np /ns /nc >nul

odin build G:\FanGS\src -out=G:\FanGS\target\debug\%date%\FanGS.exe