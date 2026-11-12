@echo off
cd /d "%~dp0"
quartus_sh -t compile.tcl
if errorlevel 1 exit /b 1
pause
