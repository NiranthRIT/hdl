@echo off
setlocal
cd /d "%~dp0"
where vsim >nul 2>nul
if errorlevel 1 (echo ModelSim or Questa vsim is not on PATH. & exit /b 1)
vsim -do sim.do
