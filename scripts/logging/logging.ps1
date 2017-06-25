function LogToFile () {
    param(
        [Parameter(Mandatory=$true)][string]$message,
        [ValidateSet("Info", "Warning","Error")][string]$type="Info"
    )

    $date = Get-Date -Format g

    $stack = @()
    $line = 0
    $trace = Get-PSCallStack

    foreach($frame in $trace){
        $frameName = $frame.Command
        $stack += $frameName
    }

    $callStack = $stack[-1..-($stack.Length - 1)]
    $functionCall = ""

    foreach($frame in $callStack){
        if($frame -ne "LogToFile"){
            $functionCall += $frame + "|"
        }
    }

    $lineArray = $trace.ScriptLineNumber -split ' '
    $lineArray = $lineArray | select -Skip 1 | select -SkipLast 1
    $line = $lineArray -join ':'

    $functionCall = $functionCall.SubString(0, $functionCall.Length -1)
    $output = "[$date][$type][$functionCall][$line]: $message"

    Write-output $output
}

#LogToFile -message "Test Message" -type Info