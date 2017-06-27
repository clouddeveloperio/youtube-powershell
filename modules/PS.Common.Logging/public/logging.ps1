function LogMessage() {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("Info","Warning","Error")][string]$Type="Info"
    )

    $callSequence = getCallSequence
    $output = "[$(Get-Date -Format g)][$Type][$callSequence] -> $Message"
    Write-Output $output
    Add-Content -Value $output -Path $script:PSLOGMODULE_DEFAULT_LOGPATH
}

function PSLogSetFilePath () {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [switch]$Force=$false
    )
    if(Test-Path $Path){
        if(-not ($Force)){
            Write-Error "Path -> $Path already exists. Not changing the log file."
        }
    }
    $script:PSLOGMODULE_DEFAULT_LOGPATH = $Path
}

Export-ModuleMember -Function "LogMessage"
Export-ModuleMember -Function "PSLogSetFilePath"