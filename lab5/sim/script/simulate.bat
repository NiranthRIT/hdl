@echo off
setlocal
cd /d "%~dp0"
where vsim >nul 2>nul
if errorlevel 1 (echo ModelSim or Questa vsim is not on PATH. & exit /b 1)
vsim -c -l batch.log -do check.do
if errorlevel 1 exit /b 1
findstr /c:"ALL LAB 5 CHECKS PASSED" batch.log >nul
if errorlevel 1 (echo PASS marker absent. Inspect batch.log. & exit /b 1)
echo Lab 5 simulation checks passed.
exit /b 0
