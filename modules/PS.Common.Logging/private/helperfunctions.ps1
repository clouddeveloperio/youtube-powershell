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

function getCallSequence() {
    $stack = @()
   
    # Get the current call stack
    $trace = Get-PSCallStack
    $trace | %{ $stack += $_.Command }      

    # Obtain the details of the line in the script being executed and the function/script names
    $lineArray = $trace.ScriptLineNumber -split ' '
    $frameTable = New-Object System.Collections.ArrayList
    $lineArray | %{ $i = 0 } { $frameItem = new-scriptFrame -frameName $stack[$i] -line $lineArray[$i]; $frameTable.Add($frameItem) | Out-Null; $i++ }
    $frameTable.Reverse()

    # Obtain only the relevant details about the actual execution of the call
    $frameTable = $frameTable | select -Skip 1 | select -SkipLast 1
    $frameTable | %{ $functionCall += "$($_.Name):$($_.Line)|"}

    # Remove the unwanted '|' at the end before returning to the invoker
    $functionCall = $functionCall.SubString(0, $functionCall.Length -1)
    return $functionCall
}

function getNewFileName () {
    $tmpFile = [System.IO.Path]::GetTempFileName()
    Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue   
    return $tmpFile.Replace('.tmp','.log')
}