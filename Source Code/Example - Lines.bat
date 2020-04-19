@Echo off
cls

Title Plot 2.0 - Demo - www.thebateam.org
Set "Path=%Path%;%cd%;%cd%\files"
Color 0a

Setlocal enabledelayedexpansion
Mode 120,50

cls

REM This is a comment...
REM This example file is created by Kvc,4:23 PM 1/2/2016
REM This file will help you in understanding the usage and importance of plot function in batch world...


REM Creating co-ordinates for the Line... 'Y = 5X + 5'

for /l %%A in (-10,1,10) do (
	SET /a _Y=5*%%A + 5
	Set "_Co_ordinate=!_Co_ordinate!%%A,!_Y! "
)



REM Creating co-ordinates for the Line... 'Y = -5X + 5'

for /l %%A in (-10,1,10) do (
	SET /a _Y=-5*%%A + 5
	Set "_Co_ordinate=!_Co_ordinate!%%A,!_Y! "
)


:End
Call plot . 0c 2 !_Co_ordinate!
batbox /c 0x0f /g 70 15 /d "Y = 5X + 5" /g 70 35 /d "Y = -5X + 5" /g 3 4 /d " Intersection of both lines is at 0,5 which proves ...the proper working of the function..."
timeout /t 2 >nul
Pause >nul
Endlocal
Exit /b