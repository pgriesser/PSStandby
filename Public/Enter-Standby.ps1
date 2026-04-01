function Enter-Standby {
    <#
    .SYNOPSIS
    Enters standby (S0 low-power idle or S3) after an optional delay.

    .DESCRIPTION
    Initiates the system to enter the system's supported standby state.
    If running in session 0 (system session), the command uses PsExec to
    trigger standby in an appropriate context.
    Supports a configurable delay before entering standby.

    .PARAMETER DelaySeconds
    Delay in seconds before entering standby. Default is 0 (immediate).
    Must be between 0 and 3600 (1 hour).

    .OUTPUTS
    None

    .EXAMPLE
    Enter-Standby

    Enters standby immediately.

    .EXAMPLE
    Enter-Standby -DelaySeconds 30

    Waits 30 seconds, then enters standby.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter()]
        [ValidateRange(0, 3600)]
        [int]$DelaySeconds = 0
    )

    # Check if we're in Session 0
    $currentSessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId
    
    if ($currentSessionId -eq 0) {
        if ($DelaySeconds -gt 0) {
            Start-Sleep -Seconds $DelaySeconds
        }

        if ((Get-PowerCapabilities).AoAc) {
            Invoke-FromInteractiveSession -ScriptPath $script:ModernStandbyPSScriptPath
        }
        else {
            Enter-S3
        }
    }
    else {
        if (-not $PSBoundParameters.ContainsKey("DelaySeconds")) {
            $DelaySeconds = 1
        }

        if ($DelaySeconds -gt 0) {
            Start-Sleep -Seconds $DelaySeconds
        }

        if ((Get-PowerCapabilities).AoAc) {
            Enter-S0ix
        }
        else {
            Enter-S3
        }
    }
}
