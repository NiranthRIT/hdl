@echo off
setlocal
cd /d "%~dp0"
where vsim >nul 2>nul
if errorlevel 1 (
  echo ERROR: vsim is not on PATH. Use the installed ModelSim/Questa command prompt.
  exit /b 1
)
vsim -c -do sim.do
exit /b %errorlevel%
