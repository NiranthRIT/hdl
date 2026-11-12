param(
    [Parameter(Mandatory=$true)][int]$CableIndex,
    [Parameter(Mandatory=$true)][int]$DeviceIndex
)
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if ($CableIndex -lt 1 -or $DeviceIndex -lt 1) { throw 'Indices start at 1.' }
Get-Command jtagconfig -ErrorAction Stop | Out-Null
Get-Command quartus_pgm -ErrorAction Stop | Out-Null
$sof = Join-Path $PSScriptRoot 'output_files\add_sub_state_machine.sof'
if (-not (Test-Path $sof)) { throw 'Compile and verify the SOF first.' }
$chain = & jtagconfig 2>&1
if ($LASTEXITCODE -ne 0) { throw "jtagconfig failed. $chain" }
$chain | Tee-Object -FilePath jtag_chain_before_program.log
$activeCable = 0
$deviceNumber = 0
$selectedDevice = $null
foreach ($line in $chain) {
    if ("$line" -match '^\s*(\d+)\)') {
        $activeCable = [int]$Matches[1]
        $deviceNumber = 0
    } elseif ("$line" -match '^\s+[0-9A-Fa-f]{8}\s+(.+)$') {
        $deviceNumber++
        if ($activeCable -eq $CableIndex -and $deviceNumber -eq $DeviceIndex) {
            $selectedDevice = $Matches[1]
        }
    }
}
if (-not $selectedDevice -or $selectedDevice -notmatch '5CSEMA5') {
    throw 'Selected chain position is not the expected Cyclone V 5CSEMA5 FPGA. Do not guess indices.'
}
$confirm = Read-Host "Confirm the connected board label is DE1-SoC 5CSEMA5F31C6, cable $CableIndex, FPGA device $DeviceIndex ($selectedDevice). Type PROGRAM"
if ($confirm -cne 'PROGRAM') { throw 'Programming cancelled.' }
& quartus_pgm -c "$CableIndex" -m JTAG -o "P;$sof@$DeviceIndex" 2>&1 |
    Tee-Object -FilePath program.log
if ($LASTEXITCODE -ne 0) { throw 'Programming failed. Inspect program.log.' }
Write-Host 'Program command returned success. Physical demonstration and instructor signoff are still required.'
