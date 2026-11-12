@echo off
setlocal
cd /d "%~dp0"
where quartus_sh >nul 2>nul
if errorlevel 1 (echo Quartus quartus_sh is not on PATH. & exit /b 1)
quartus_sh -t compile.tcl > build.log 2>&1
if errorlevel 1 (type build.log & exit /b 1)
if not exist output_files\add_sub_state_machine.sof (echo Missing SOF. & exit /b 1)
echo Compiled successfully. Inspect build.log and Quartus reports before programming.
echo This script DOES NOT program the board.
exit /b 0
