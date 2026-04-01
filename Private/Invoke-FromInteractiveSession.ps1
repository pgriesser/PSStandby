function Invoke-FromInteractiveSession {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ScriptPath,

        [Parameter()]
        [string]$CommandParameters
    )

    $sessionID = (Get-Process -Name explorer | Select-Object -First 1).SessionId

    if ($PSCmdlet.ShouldProcess("Session $sessionID", "Invoke $(Split-Path -Leaf $ScriptPath)")) {
        $command = "Invoke-Expression ([string]::join([environment]::newline,(Get-Content $ScriptPath))) ; `$result = ($(Get-FunctionName -ScriptPath $ScriptPath) $CommandParameters) ; if (`$result -is [bool]) { exit ([int](-not `$result)) }"

        psexec -nobanner -i $sessionID powershell.exe -NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -Command "& $command" | Out-Null
        return $LASTEXITCODE -eq 0
    }
}

function Get-FunctionName {
    param (
        [string]$ScriptPath
    )

    $content = Get-Content -Path $ScriptPath -Raw
    if ($content -match 'function\s+([a-zA-Z0-9_-]+)') {
        return $matches[1]
    }
    else {
        throw "No function definition found in $ScriptPath"
    }
}
