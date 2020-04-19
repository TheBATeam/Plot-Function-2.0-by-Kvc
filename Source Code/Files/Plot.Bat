@Echo off
Setlocal enabledelayedexpansion

REM Description:
REM This Plot function simply plots a Character (maybe '*') on the cmd console...
REM As specified to the function through passed arguments or a 'Plot file'.
REM version 2.0 is much more intelligent than Ver.1.0, with some added features of numerical representaion along points, and auto-adjustable scaling
REM All of the Code and Algorithm are the result of free time consumption Of kvc... :D 

REM This Function is Created by Kvc At,1:43 PM 1/1/2016 ... So, It is a new year gift from
REM #TheBATeam to all the other batch programmers...

REM It maybe useful in mathematical calculations,graphs etc.

REM We hope, you'll like our work... Show your love and Response at our Blog:
REM www.thebateam.org


Set Error=1
If /i "%~1" == "" (goto :help)
If /i "%~2" == "" (goto :help)

Set Error=0
If /i "%~1" == "/h" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "ver" (Echo.2.0&&goto :Eof)


REM Setting-up necessary variables for the function...
Set "_Char=%~1"
Set "_Char=!_Char:~0,1!"
Set _Color=%~2
Set _STYLE=%~3
Set "_File=%~5"
Set _String=
Set _Count=0

Set _Min_X=0
Set _Min_Y=0
Set _Max_X=0
Set _Max_Y=0

If /i "%~4" == "-F" (goto :For_Loop)

:Loop
If /i "%~4" == "" (Goto :Next)
If /i "%~5" == "" (Goto :Next)
Set /a _Y=%~5*-1

Set _X_!_Count!=%~4
Set _Y_!_Count!=!_Y!

Set /a _Count+=1

If %~4 LSS !_Min_X! (Set _Min_X=%~4)
If %~4 Gtr !_Max_X! (Set _Max_X=%~4)
If !_Y! LSS !_Min_Y! (Set _Min_Y=!_Y!)
If !_Y! Gtr !_Max_Y! (Set _Max_Y=!_Y!)

Shift /4
Shift /4
goto :Loop

:For_Loop
If Not EXIST "!_File!" (Exit /b 404)
For /f "usebackq eol=# Tokens=1,2 delims=," %%A in ("!_File!") do (
Set /a _Y=%%B*-1

Set _X_!_Count!=%%A
Set _Y_!_Count!=!_Y!

Set /a _Count+=1

If %%A LSS !_Min_X! (Set _Min_X=%%A)
If %%A Gtr !_Max_X! (Set _Max_X=%%A)
If !_Y! LSS !_Min_Y! (Set _Min_Y=!_Y!)
If !_Y! Gtr !_Max_Y! (Set _Max_Y=!_Y!)
)

:Next
Call :Setup_Graph_Situation !_STYLE!
REM Setting-up the Main String...
For /l %%A in (0,1,!_count!) do (
	Set /a _X=!_X_%%A! / !_Scaling_Factor_For_X! 2>nul
	Set /a _Y=!_Y_%%A! / !_Scaling_Factor_For_Y! 2>nul

	Set "_String=!_String!/g !_X! !_Y! /d "!_Char!" "
)

:End
Batbox /c 0x08 !_Final! /o !_Mid_X! !_Mid_Y! /c 0x07 !_Numbering! /c 0x!_Color! !_String! /c 0x07
exit /b 0




REM Extra Sub_Function created by Kvc...
REM 1:44 PM 1/1/2016

:Setup_Graph_Situation
If /i "%~1" == "0" (
	Set _ver_line=250
	Set _hor_line=250
	Set _Centre=250
)
If /i "%~1" == "1" (
	Set _ver_line=179
	Set _hor_line=196
	Set _Centre=197
)
If /i "%~1" == "2" (
	Set _ver_line=197
	Set _hor_line=197
	Set _Centre=197
)

REM Checking current console size...
For /f "Tokens=2" %%A in ('mode con ^| find "Lines:"') do (Set _Lines=%%A)
For /f "Tokens=2" %%A in ('mode con ^| find "Columns:"') do (Set _Columns=%%A)

If /i "%_Lines%" == "300" (Set _Lines=25)

Set /a _Lines-=1
Set /a _Columns-=1

Set /a _Mid_X=!_Columns! / 2
Set /a _Mid_Y=!_Lines! / 2

Set _Horizontal=
Set _Vertical=

For /l %%A in (0,1,!_columns!) do (If /i "%%A" == "!_Mid_X!" (Set "_Horizontal=!_Horizontal!/a !_Centre! ") Else (Set "_Horizontal=!_Horizontal!/a !_hor_line! "))
For /l %%A in (0,1,!_Lines!) do (Set "_Vertical=!_Vertical!/g !_Mid_X! %%A /a !_Ver_line! ")



REM Scaling algorithm by kvc... To scale Both axis, so all specified co-ordinates should be on the graph...
REM =// Removing negative sign... Or finding their absolute values...
For %%A in (_Max_X _Max_Y _Min_X _Min_Y) do (Set %%A=!%%A:-=!)

REM == For X-Axis
Set /a _Required_Divisions=!_Max_X!+!_Min_X!
Set /a _Scaling_Factor_For_X=(!_Required_Divisions! / !_Mid_X!) + 1

REM == For Y-Axis
Set /a _Required_Divisions=!_Max_Y!+!_Min_Y!
Set /a _Scaling_Factor_For_Y=(!_Required_Divisions! / !_Mid_Y!) + 1

REM Numbering Algorithm by kvc... To print Numbers besides the point on axis...
REM Note: The co-ordinates for numbering system are after the change of origin of console from top left corner to the centre of the console...

REM == For origin...
Set "_Numbering=/g -1 1 /d "0" "

REM == For X-Axis
For /l %%A in (5,5,!_Mid_X!) do (
	Set /a _Digit=%%A*!_Scaling_Factor_For_X!
	Set "_Numbering=!_Numbering! /g %%A 0 /a !_Ver_line! /g -%%A 0 /a !_Ver_line! /g %%A 1 /d "!_Digit!" /g -%%A 1 /d "-!_Digit!" "
)

REM == For Y-Axis
For /l %%A in (5,5,!_Mid_Y!) do (
	Set /a _Digit=%%A*!_Scaling_Factor_For_Y!
	Set "_Numbering=!_Numbering! /g 0 -%%A /a !_hor_line! /g 0 %%A /a !_hor_line! /g -3 -%%A /d "!_Digit!" /g -4 %%A /d "-!_Digit!" "
)
Set "_Final=/g 0 !_Mid_Y! !_horizontal! !_vertical! /g !_Mid_X! !_Mid_Y! /a !_Centre! "
Goto :eof


:help
Echo.
Echo. This function simply plots a Specified Character on the cmd console at
Echo. the specified location. The Center of the console is taken as origin ^&
Echo. then points are plotted against that origin.
ECHo. It maybe helpful in various mathematical operations, or graphs.
Echo.
Echo. Syntax: Call Plot [Char] [Color] [Style] [Co-ord] [Co-ord] [Co-ord] ...
Echo.         Call Plot [Char] [Color] [Style] -F "File.Plot"
Echo.         Call Plot [-h ^| help ^| /^? ^| /h]
Echo.         Call Plot [ver]
Echo.         
Echo. Where:
Echo. Char:		Character to represent printing of Points on console...
Echo. Color:		Hexadecimal color code for the Character...
Echo. Ver:		To know version of current plot Function...
Echo. File.plot:	Plot File, It will contain all the co-ordinates to be 
Echo. 		printed on the cmd console...
Echo. Co-Ord:	Co-Ordinates in the form of {X,Y}...
Echo. Style:		Changes the display style of the graph...
Echo.       		Valid values: 0 or 1 or 2 ...
ECHo. -h,help,/h,/?:	To get this help menu...
Echo.
Echo. Example: Call Plot * 0a 1 2,2 3,3 4,4 5,5 6,6 7,7 8,8
Echo. Example: Call Plot * 0c 2 -F "Example.Plot"
Echo. 
Echo. For more: visit, www.thebateam.org #TheBATeam
Exit /b %error%
