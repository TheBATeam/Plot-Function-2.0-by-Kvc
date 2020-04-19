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


REM Creating co-ordinates for the Line... 'Y = X^2'

for /l %%A in (-10,1,10) do (
	SET /a _Y=%%A*%%A
	Set "_Co_ordinate=!_Co_ordinate!%%A,!_Y! "
)



REM Creating co-ordinates for the Line... 'Y = -X^2'

for /l %%A in (-10,1,10) do (
	SET /a _Y=%%A*%%A
	Set "_Co_ordinate=!_Co_ordinate!%%A,-!_Y! "
)


:End
Call plot . 0a 2 !_Co_ordinate!
batbox /c 0x0f /g 70 15 /d "Y=X" /a 253 /d " { Upward Parabola }" /g 70 35 /d "Y=-X" /a 253 /d " { Downward Parabola }"
timeout /t 2 >nul
Pause >nul
Endlocal
Exit /b