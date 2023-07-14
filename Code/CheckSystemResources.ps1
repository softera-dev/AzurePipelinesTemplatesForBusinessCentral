#Requires -Version 7.3.5

set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$OS = Get-CimInstance -ClassName Win32_OperatingSystem
$SystemDrive = $OS.SystemDrive -replace '\:$'
$FreeSystemDriveSpaceInBytes = (Get-PSDrive -Name $SystemDrive).Free
$FreePhysicalMemoryInBytes = $OS.FreePhysicalMemory * 1KB

$ResourceErrors = @(
    $RequiredFreeSystemDriveSpaceInBytes = 10GB
    if ($FreeSystemDriveSpaceInBytes -lt $RequiredFreeSystemDriveSpaceInBytes) {
        "##[error]There is not enough disk space left. There must be at least $(
            '{0:0.#,.}' -f ($RequiredFreeSystemDriveSpaceInBytes / 1GB)) GB."
    }

    $RequiredFreePhysicalMemoryInBytes = 4GB
    if ($FreePhysicalMemoryInBytes -lt $RequiredFreePhysicalMemoryInBytes) {
        "##[error]There is not enough operating memory space left. There must be at least $(
            '{0:0.#,.}' -f ($RequiredFreePhysicalMemoryInBytes / 1GB)) GB."
    }
)

if ($ResourceErrors) {
    $ResourceErrors | Out-Host
    Write-Error -Message 'Insufficient resources to run pipeline.'
}