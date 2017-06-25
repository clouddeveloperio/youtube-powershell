function new-scriptFrame(){
    param(
        [Parameter(Mandatory=$true)][string]$frameName,
        [Parameter(Mandatory=$true)][string]$line
    )
    return New-Object PSObject @{
        Name = $frameName
        Line = $line
    }
}
function LogToFile () {
    param(
        [Parameter(Mandatory=$true)][string]$message,
        [ValidateSet("Info", "Warning","Error")][string]$type="Info"
    )

    $date = Get-Date -Format g
    $trace = Get-PSCallStack

    $stack = @()
    $trace | %{ $stack += $_.Command }
       
    $lineArray = $trace.ScriptLineNumber -split ' '

    $frameTable = New-Object System.Collections.ArrayList
    $lineArray | %{ $i = 0 } { $frameItem = new-scriptFrame -frameName $stack[$i] -line $lineArray[$i]; $frameTable.Add($frameItem) | Out-Null; $i++ }
    $frameTable.Reverse()
    $frameTable = $frameTable | select -Skip 1 | select -SkipLast 1

    $frameTable | %{ $functionCall += "$($_.Name):$($_.Line)|"}
    $functionCall = $functionCall.SubString(0, $functionCall.Length -1)

    $output = "[$date][$type][$functionCall]: $message"
    Write-output $output
}

#LogToFile -message "Test Message" -type Info