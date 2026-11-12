@echo off
setlocal
cd /d "%~dp0"
where quartus_sh >nul 2>nul
if errorlevel 1 (
  echo ERROR: quartus_sh is not on PATH. Use the installed Quartus command prompt.
  exit /b 1
)
quartus_sh -t compile.tcl
exit /b %errorlevel%
