#Requires -Version 7.3.5

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

$OS = Get-CimInstance -ClassName Win32_OperatingSystem
$SystemDrive = $OS.SystemDrive -replace '\:$'
$FreeSystemDriveSpaceInBytes = (Get-PSDrive -Name $SystemDrive).Free
$FreePhysicalMemoryInBytes = $OS.FreePhysicalMemory * 1KB

$ResourceErrors = @(
    $RequiredFreeSystemDriveSpaceInBytes = 10000GB
    if ($FreeSystemDriveSpaceInBytes -lt $RequiredFreeSystemDriveSpaceInBytes) {
        -join @(
            '##vso[task.logissue type=error;]'
            'There is not enough disk space left. There must be at least '
            "$('{0:0.#,.}' -f ($RequiredFreeSystemDriveSpaceInBytes / 1GB)) GB."
        )
    }

    $RequiredFreePhysicalMemoryInBytes = 4000GB
    if ($FreePhysicalMemoryInBytes -lt $RequiredFreePhysicalMemoryInBytes) {
        -join @(
            '##vso[task.logissue type=error;]'
            'There is not enough operating memory space left. There must be at least '
            "$('{0:0.#,.}' -f ($RequiredFreePhysicalMemoryInBytes / 1GB)) GB."
        )
    }
)

if ($ResourceErrors) {
    $ResourceErrors += -join @(
        '##vso[task.logissue type=error;]'
        'Insufficient resources to run pipeline.'
    )
    $ResourceErrors | Out-Information
    exit(1)
}
