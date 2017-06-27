
$publicFiles = @( Get-ChildItem $PSScriptRoot\public\*.ps1 )
$privateFiles = @( Get-ChildItem $PSScriptRoot\private\*.ps1 )

@( $publicFiles + $privateFiles ) | %{
    $script = $_
    try {
        Write-Verbose "Importing module file -> $($script.Fullname)" -Verbose
        . $script.Fullname
    }
    catch {
        Write-Error "Failed to import module file '$($script.Fullname)' -> $_" -Verbose
    }
}

function InitializePSLOGMODULE () {
    $script:PSLOGMODULE_DEFAULT_LOGPATH = getNewFileName
}

InitializePSLOGMODULE

Write-Verbose "PS.Common.Logging module will write to: $script:PSLOGMODULE_DEFAULT_LOGPATH" -Verbose