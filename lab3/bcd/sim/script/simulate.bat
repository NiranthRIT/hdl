@echo off
cd /d "%~dp0"
where vsim >nul 2>nul
if errorlevel 1 (echo Open ModelSim in this directory and enter do sim.do & exit /b 1)
vsim -do sim.do
