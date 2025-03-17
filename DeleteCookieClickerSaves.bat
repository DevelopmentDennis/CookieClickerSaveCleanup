@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Set your bakery name here
set bakeryName=[YOUR_BAKERY_NAME]

call :strlen result bakeryName

set /A bakeryLenght=%result% + 1

REM In my case this script is placed on the desktop
REM the cookie clicker save files are located in Downloads
REM adjust the below navigation to your needs
cd ..
cd Downloads

set /A largest = 0

REM iterate all files in downloads with the correct name pattern
REM this will only work for up to 99 save files
for %%k in (%bakeryName%*.txt) do (
	set b=%%k
	set var=!b:~%bakeryLenght%,2!
	REM Check if it is number
	set /a number=!var! >nul 2>&1
	set /a number=!number! / 1 >nul 2>&1
	if "!var!" == "!number!" (
		if !var! GTR !largest! (set largest=!var!) 
	) else (
		set var=!var:~0,-1!
		set /a number=!var! >nul 2>&1
		set /a number=!number! / 1 >nul 2>&1
		if "!var!" == "!number!" (
		if !var! GTR !largest! (set largest=!var!) 
		)
	)
)

REM print the name of the newest file
set largestFile=%bakeryName% (%largest%).txt
echo most recent file is %largestFile%

if %largest% EQU 0 (
	echo nothing found to delete
	pause
	goto :eof
)

REM delete all files except the newest
for %%i in (%bakeryName%*.txt) do (
	if "%%i" EQU "%largestFile%" ( echo dont delete most recent save ) else ( 
	del "%%i" 
	echo old save deleted
	)
)

REM rename the newest file 
ren "%largestFile%" "%bakeryName%.txt"


echo "Old files deleted and most recent file renamed to %bakeryName%.txt"
pause

goto :eof


REM ********* function *****************************
REM calculates the length of a string
:strlen <resultVar> <stringVar>
(   
    setlocal EnableDelayedExpansion
    (set^ tmp=!%~2!)
    if defined tmp (
        set "len=1"
        for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            if "!tmp:~%%P,1!" NEQ "" ( 
                set /a "len+=%%P"
                set "tmp=!tmp:~%%P!"
            )
        )
    ) ELSE (
        set len=0
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)
