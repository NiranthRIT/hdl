param([Parameter(Mandatory=$true)][string]$Vsim)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Vsim -PathType Leaf)) { throw 'Give the full path to vsim.exe from the installed ModelSim or Questa version.' }
Push-Location $PSScriptRoot
try {
  & $Vsim -c -do 'do run_all.do'
  if ($LASTEXITCODE -ne 0) { throw "Simulation failed with exit code $LASTEXITCODE. Do not proceed to hardware." }
} finally { Pop-Location }
